class API::V1::OccupationStandardWorkProcesses::Relationships::SkillsController < API::V1::OccupationStandardWorkProcesses::RelationshipsController
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
end
