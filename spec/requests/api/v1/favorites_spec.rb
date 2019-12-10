require 'rails_helper'

RSpec.describe API::V1::FavoritesController, type: :request do
  describe "POST #create" do
    let(:path) { "/api/v1/users/#{user.id}/relationships/favorites" }

    context "with valid params" do
      let(:os) { create(:occupation_standard) }
      let(:params) {
        {
          data: {
            type: "occupation_standard",
            id: os.id.to_s,
          }
        }
      }
      let(:user) { create(:user) }
      let(:header) { auth_header(user) }

      it_behaves_like "authorization", :post

      context "when updating own favorite" do
        context "when occupation_standard is not already favorited" do
          it "creates a new relationship record" do
            expect{
              post path, params: params, headers: header
            }.to change(Relationship, :count).by(1)
          end

          it "sets favorite and returns success" do
            post path, params: params, headers: header
            expect(response).to have_http_status(:success)
            user.reload
            expect(user.favorites).to eq [os]
          end
        end

        context "when occupation_standard is already favorited" do
          before { user.favorites << os }

          it "does not create a new relationship record" do
            expect{
              post path, params: params, headers: header
            }.to_not change(Relationship, :count)
          end

          it_behaves_like "success", :post
        end
      end

      context "when updating favorite for someone else" do
        it_behaves_like "unauthorized", :post do
          let(:header) { auth_header(create(:user)) }
        end
      end
    end
  end
end
