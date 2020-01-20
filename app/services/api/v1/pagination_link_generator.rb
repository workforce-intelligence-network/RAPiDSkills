class API::V1::PaginationLinkGenerator
  attr_accessor :url, :options, :query_params
  attr_reader :per_page, :page, :total_pages

  def initialize(request:, query_params:, total_pages:)
    @url = request.base_url + request.path
    @query_params = query_params.to_h
    page_params = @query_params.delete(:page) || {}
    @page = page_params[:number].to_i
    @per_page = page_params[:size].to_i
    @total_pages = total_pages
    @options = {
      links: {},
      meta: {
        current_page: page == 0 ? 1 : page,
        total_pages: total_pages,
      },
    }
  end

  def call
    options[:links][:self] = generate_url(page)

    # If page is 0, it means pagination info has not been passed. Skip
    # displaying the first, last page links in that case.
    if page > 0
      options[:links][:first] = generate_url(1)
      options[:links][:last] = generate_url(total_pages)
    end

    options[:links][:prev] = generate_url(page - 1) if page > 1
    options[:links][:next] = generate_url(page + 1) if page < total_pages

    options
  end

  private

  def generate_url(page)
    [url, url_params(page)].compact.join("?")
  end

  def url_params(page)
    if include_pagination?
      query_params.merge!(page: {})
      query_params[:page][:size] = per_page
      query_params[:page][:number] = page
    end
    query_params.to_query if query_params.any?
  end

  def include_pagination?
    page != 0 || per_page != 0
  end
end
