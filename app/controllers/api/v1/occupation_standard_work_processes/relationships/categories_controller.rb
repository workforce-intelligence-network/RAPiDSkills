class API::V1::OccupationStandardWorkProcesses::Relationships::CategoriesController < API::V1::OccupationStandardWorkProcesses::RelationshipsController
  def index
    @categories = @oswp.categories
    options = {
      links: {
        self: @oswp.relationships_url('categories'),
        related: @oswp.related_url('categories'),
      }
    }
    render json: API::V1::OccupationStandardWorkProcess::Relationships::CategorySerializer.new(@categories, options)
  end
end
