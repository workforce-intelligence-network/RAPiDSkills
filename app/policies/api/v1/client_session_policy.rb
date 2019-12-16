class API::V1::ClientSessionPolicy < ApplicationPolicy
  attr_reader :user, :client_session

  def initialize(user, client_session)
    @user = user
    @client_session = client_session
  end

  def user?
    client_session.user == user
  end
end
