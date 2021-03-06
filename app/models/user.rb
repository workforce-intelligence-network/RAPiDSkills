class User < ApplicationRecord
  devise :database_authenticatable, :trackable,
         :recoverable, :rememberable, :validatable

  enum role: [:lead, :basic, :admin]

  belongs_to :employer, class_name: 'Organization', optional: true
  has_many :data_imports
  has_many :client_sessions
  has_many :occupation_standards, foreign_key: :creator_id
  has_many :relationships
  has_many :favorites, -> { order(id: :desc) }, through: :relationships,
    class_name: 'OccupationStandard', source: :occupation_standard

  delegate :title, to: :employer, prefix: true

  def create_api_access_token!
    client_session = create_session!
    client_session.token
  end

  def create_session!
    client_sessions.create
  end

  def destroy_session!(session_identifier)
    client_sessions.where(id: session_identifier).destroy_all
  end

  def joined?
    last_sign_in_at.present?
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
