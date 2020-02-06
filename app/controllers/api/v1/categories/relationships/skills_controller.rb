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
end
