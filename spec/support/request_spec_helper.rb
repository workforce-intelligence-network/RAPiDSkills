module RequestSpecHelper

  include Warden::Test::Helpers

  def self.included(base)
    base.before(:each) { Warden.test_mode! }
    base.after(:each) { Warden.test_reset! }
  end

  def sign_in(resource)
    login_as(resource, scope: warden_scope(resource)) if resource
  end

  def sign_out(resource)
    logout(warden_scope(resource)) if resource
  end

  def json
    JSON.parse(response.body)
  end

  def auth_header(user, token=nil)
    if user
      token ||= user.create_api_access_token!
      { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
    end
  end

  def invalid_token_header(user=nil)
    if user
      user.encrypted_password = "abc"
      token = user.create_api_access_token!
    else
      token = "abc"
    end

    { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
  end

  def bad_auth_header
    { "HTTP_AUTHORIZATION" => "Bearer badtoken" }
  end

  private

  def warden_scope(resource)
    resource.class.name.underscore.to_sym
  end

end
