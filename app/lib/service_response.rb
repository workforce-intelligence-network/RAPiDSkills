class ServiceResponse
  attr_accessor :success, :error, :data

  def initialize(success: false, error: nil, data: {})
    @success = success
    @error = error
    @data = data
  end

  def success?
    success
  end
end
