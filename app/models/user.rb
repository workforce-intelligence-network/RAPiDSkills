class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :trackable,
         :recoverable, :rememberable, :validatable

  enum role: [:lead, :basic, :admin]

  belongs_to :employer, class_name: 'Organization', optional: true
  has_many :data_imports
  has_many :client_sessions
  has_many :relationships
  has_many :favorites, -> { order(id: :desc) }, through: :relationships,
    class_name: 'OccupationStandard', source: :occupation_standard

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def create_api_access_token!
    session_identifier = User.new_token
    client_sessions.create(identifier: session_identifier)
    JsonWebToken.encode(authentication_payload(session_identifier))
  end

  def destroy_session!(session_identifier)
    client_sessions.where(identifier: session_identifier).destroy_all
  end

  private

  def authentication_payload(session_identifier)
    {
      id: id,
      encrypted_password: encrypted_password,
      session_identifier: session_identifier,
    }
  end
end
