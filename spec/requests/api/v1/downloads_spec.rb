require 'rails_helper'

RSpec.describe API::V1::DownloadsController, type: :request do
  describe "POST #create" do
    let(:path) { "/api/v1/downloads" }

    context "with valid params" do
      let(:os) { create(:occupation_standard) }
      let(:params) {
        {
          data: {
            type: "downloads",
            relationships: {
              downloadable: {
                data: {
                  type: "occupation_standards",
                  id: os.id.to_s,
                }
              }
            }
          }
        }
      }

      it "triggers pdf and excel generation" do
        expect(GenerateOccupationStandardPdfJob).to receive(:perform_later).with(os.id.to_s)
        expect(GenerateOccupationStandardExcelJob).to receive(:perform_later).with(os.id.to_s)
        post path, params: params
      end

      it "returns accepted http status" do
        post path, params: params
        expect(response).to have_http_status(:accepted)
      end
    end

    context "with invalid params" do
      context "when missing relationship data" do
        let(:params) {
          {
            data: {
              type: "downloads"
            }
          }
        }

        it "does not trigger pdf or excel generation" do
          expect(GenerateOccupationStandardPdfJob).to_not receive(:perform_later)
          expect(GenerateOccupationStandardExcelJob).to_not receive(:perform_later)
          post path, params: params
        end

        it "returns 422 http status" do
          post path, params: params
          expect(response).to have_http_status(:unprocessable_entity)
          expect(json["errors"][0]["status"]).to eq "422"
          expect(json["errors"][0]["detail"]).to match "empty: relationships"
        end
      end

      context "when bad occupation standard id" do
        let(:params) {
          {
            data: {
              type: "downloads",
              relationships: {
                downloadable: {
                  data: {
                    type: "occupation_standards",
                    id: "999"
                  }
                }
              }
            }
          }
        }

        it "does not trigger pdf or excel generation" do
          expect(GenerateOccupationStandardPdfJob).to_not receive(:perform_later)
          expect(GenerateOccupationStandardExcelJob).to_not receive(:perform_later)
          post path, params: params
        end

        it "returns not found http status" do
          post path, params: params
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
