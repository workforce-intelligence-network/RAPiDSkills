class API::V1::Categories::Relationships::SkillsController < API::V1::Categories::RelationshipsController
  def index
    @osss = @category.occupation_standard_skills
    options = {
      links: {
        self: @category.relationships_url('skills'),
        related: @category.related_url('occupation_standard_skills'),
      }
    }
    render json: API::V1::Relationships::OccupationStandardSkillSerializer.new(@osss, options)
  end

  def destroy
    authorize [:api, :v1, @category], :delete_skill?
    object_params.each do |object_param|
      oss = @category.occupation_standard_skills.find_by(id: object_param[:id])
      oss.destroy if oss
    end
    head :no_content
  end

  private

  def object_params
    params.require(:data)
  end
end
