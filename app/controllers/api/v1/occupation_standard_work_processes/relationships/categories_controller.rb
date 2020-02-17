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

  def destroy
    authorize [:api, :v1, @oswp], :delete_category?
    begin
      Category.transaction do
        object_params.each_with_index do |object_param, index|
          @pointer = "/data/#{index}"
          category = @oswp.categories.find_by(id: object_param[:id])
          category.destroy if category
        end
      end
      head :no_content
    rescue Exception => e
      render_error(
        status: :unprocessable_entity,
        detail: "Category with skills may not be deleted",
        source_pointer: @pointer,
      )
    end
  end

  private

  def object_params
    params.require(:data)
  end
end
