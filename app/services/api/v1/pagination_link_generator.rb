class API::V1::PaginationLinkGenerator
  attr_accessor :url, :options
  attr_reader :per_page, :page, :total_pages

  def initialize(request:,  total_pages:, page_params:)
    @url = request.base_url + request.path
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

    if page > 1
      options[:links][:prev] = generate_url(page - 1)
    end

    if page < total_pages
      options[:links][:next] = generate_url(page + 1)
    end

    options
  end

  private

  def generate_url(page)
    [url, url_params(page)].compact.join("?")
  end

  def url_params(page)
    if include_pagination?
      url_params = { page: {} }
      url_params[:page][:size] = per_page
      url_params[:page][:number] = page
      url_params.to_query
    end
  end

  def include_pagination?
    page != 0 || per_page != 0
  end
end
