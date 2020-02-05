require 'rails_helper'

RSpec.describe API::V1::CategoriesController, type: :request do
  describe "POST #create" do
    let(:path) { "/api/v1/categories" }
    let(:user) { create(:user) }
    let(:header) { auth_header(user) }
    let(:params) {
      {
        data: {
          type: "category",
          attributes: {
            name: "My category",
            sort_order: 2,
          },
          relationships: {
            work_process: {
              data: {
                type: "work_process",
                id: oswp.id.to_s,
              }
            }
          }
        }
      }
    }

    context "when user belongs to occupation_standard" do
      let(:os) { create(:occupation_standard, creator: user) }
      let(:oswp) { create(:occupation_standard_work_process, occupation_standard: os) }

      it_behaves_like "authentication", :post

      context "with valid parameters" do
        context "when work process belongs to standard" do
          it "creates a new category" do
            expect{
              post path, params: params, headers: header
            }.to change(Category, :count).by(1)
            category = Category.last
            expect(category.name).to eq "My category"
            expect(category.sort_order).to eq 2
            expect(category.occupation_standard_work_process).to eq oswp
          end

          it "returns correct response" do
            post path, params: params, headers: header
            expect(response).to have_http_status(:success)
            category = Category.last
            expect(json["links"]["self"]).to eq api_v1_category_url(category)
            expect(json["data"]["id"]).to eq category.id.to_s
            expect(json["data"]["type"]).to eq "category"
            expect(json["data"]["attributes"]["name"]).to eq "My category"
            expect(json["data"]["links"]["self"]).to eq api_v1_category_url(category)
          end
        end

        context "when work process does not belong to standard" do
          let(:oswp) { create(:occupation_standard_work_process) }

          it "does not create a new category" do
            expect{
              post path, params: params, headers: header
            }.to_not change(Category, :count)
          end

          it_behaves_like "forbidden", :post
        end
      end

      context "with invalid parameters" do
        context "when name is blank" do
          let(:params) {
            {
              data: {
                type: "category",
                attributes: {
                  name: "",
                },
                relationships: {
                  work_process: {
                    data: {
                      type: "work_process",
                      id: oswp.id.to_s,
                    }
                  }
                }
              }
            }
          }

          it "does not create new category" do
            expect{
              post path, params: params, headers: header
            }.to_not change(Category, :count)
          end

          it "returns 422 with an error message" do
            post path, params: params, headers: header
            expect(response).to have_http_status(:unprocessable_entity)
            expect(json["errors"][0]["status"]).to eq "422"
            expect(json["errors"][0]["detail"]).to eq "Name can't be blank"
          end
        end

        context "when category already exists" do
          let!(:category) { create(:category, occupation_standard_work_process: oswp) }
          let(:params) {
            {
              data: {
                type: "category",
                attributes: {
                  name: category.name,
                },
                relationships: {
                  work_process: {
                    data: {
                      type: "work_process",
                      id: oswp.id.to_s,
                    }
                  }
                }
              }
            }
          }

          it "does not create new category" do
            expect{
              post path, params: params, headers: header
            }.to_not change(Category, :count)
          end

          it "returns 422 with an error message" do
            post path, params: params, headers: header
            expect(response).to have_http_status(:unprocessable_entity)
            expect(json["errors"][0]["status"]).to eq "422"
            expect(json["errors"][0]["detail"]).to eq "Name has already been taken"
          end
        end

        context "with bad work process ids" do
          it_behaves_like "not found", :post do
            let(:params) {
              {
                data: {
                  type: "category",
                  attributes: {
                    name: "this is a new category",
                  },
                  relationships: {
                    work_process: {
                      data: {
                        type: "work_process",
                        id: 9999,
                      }
                    }
                  }
                }
              }
            }
          end
        end

        context "when missing relationships key" do
          let(:params) {
            {
              data: {
                type: "category",
                attributes: {
                  description: "new category",
                }
              }
            }
          }

          it "returns 422 http status" do
            post path, params: params, headers: header
            expect(response).to have_http_status(:unprocessable_entity)
            expect(json["errors"][0]["status"]).to eq "422"
            expect(json["errors"][0]["detail"]).to match "empty: relationships"
          end
        end
      end
    end

    context "when user does not belong to occupation standard" do
      it_behaves_like "forbidden", :post do
        let(:os) { create(:occupation_standard) }
        let(:oswp) { create(:occupation_standard_work_process, occupation_standard: os) }
      end
    end
  end

  describe "PATCH #update" do
    let(:path) { "/api/v1/categories/#{category.id}" }
    let(:user) { create(:user) }
    let(:os) { create(:occupation_standard) }
    let(:oswp) { create(:occupation_standard_work_process, occupation_standard: os) }
    let!(:category) { create(:category, occupation_standard_work_process: oswp) }
    let(:header) { auth_header(user) }
    let(:params) {
      {
        data: {
          type: "category",
          id: category.id.to_s,
          attributes: {
            name: "updated name",
            sort_order: 5,
          }
        }
      }
    }

    context "when user belongs to occupation_standard" do
      let(:os) { create(:occupation_standard, creator: user) }

      it_behaves_like "authentication", :patch

      context "with valid parameters" do
        it "does not create a new category" do
          expect{
            patch path, params: params, headers: header
          }.to_not change(Category, :count)
        end

        it "returns correct response" do
          patch path, params: params, headers: header
          expect(response).to have_http_status(:success)
          expect(json["links"]["self"]).to eq api_v1_category_url(category)
          expect(json["data"]["id"]).to eq category.id.to_s
          expect(json["data"]["type"]).to eq "category"
          expect(json["data"]["attributes"]["name"]).to eq "updated name"
          expect(json["data"]["attributes"]["sort_order"]).to eq 5
          expect(json["data"]["links"]["self"]).to eq api_v1_category_url(category)
        end
      end

      context "with invalid parameters" do
        let(:params) {
          {
            data: {
              type: "category",
              id: category.id.to_s,
              attributes: {
                name: "",
              }
            }
          }
        }

        it "returns 422 with an error message" do
          patch path, params: params, headers: header
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json["errors"][0]["status"]).to eq "422"
          expect(json["errors"][0]["detail"]).to eq "Name can't be blank"
        end
      end

      context "with bad category id" do
        it_behaves_like "not found", :patch do
          let(:path) { "/api/v1/categories/999" }
        end
      end
    end

    context "when user does not belong to occupation standard" do
      it_behaves_like "forbidden", :patch
    end
  end

  describe "GET #show" do
    let(:path) { "/api/v1/categories/#{category.id}" }
    let(:category) { create(:category) }

    context "with valid category id" do
      it "returns the correct data" do
        get path
        expect(response).to have_http_status(:success)
        expect(json["links"]["self"]).to eq api_v1_category_url(category)
        expect(json["data"]["id"]).to eq category.id.to_s
        expect(json["data"]["type"]).to eq "category"
        expect(json["data"]["attributes"]["name"]).to eq category.name
        expect(json["data"]["attributes"]["sort_order"]).to eq category.sort_order
        expect(json["data"]["links"]["self"]).to eq api_v1_category_url(category)
      end
    end

    context "with bad category id" do
      it_behaves_like "not found", :get do
        let(:path) { "/api/v1/categories/999" }
        let(:params) { {} }
        let(:header) { {} }
      end
    end
  end
end
