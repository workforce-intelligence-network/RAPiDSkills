class API::V1::OccupationStandardWorkProcesses::Relationships::SkillsController < API::V1::OccupationStandardWorkProcesses::RelationshipsController
  after_action :generate_download_docs, only: :destroy, if: -> { response.successful? }

  def index
    @osss = @oswp.occupation_standard_skills
    options = {
      links: {
        self: @oswp.relationships_url('skills'),
        related: @oswp.related_url('occupation_standard_skills'),
      }
    }
    render json: API::V1::Relationships::OccupationStandardSkillSerializer.new(@osss, options)
  end

  def destroy
    authorize [:api, :v1, @oswp], :delete_skill?
    object_params.each do |object_param|
      oss = @oswp.occupation_standard_skills.find_by(id: object_param[:id])
      oss.destroy if oss
    end
    head :no_content
  end

  private

  def object_params
    params.require(:data)
  end

  def generate_download_docs
    @oswp.occupation_standard.generate_download_docs
  end
end
