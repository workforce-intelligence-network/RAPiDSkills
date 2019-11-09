FactoryBot.define do
  factory :client_session do
    user
    identifier { SecureRandom.urlsafe_base64 }
  end
end
