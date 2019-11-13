require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "welcome_email" do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.welcome_email(user.id) }

    it "renders the headers" do
      expect(mail.subject).to match("Welcome to RAPiDSkills")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["noreply@rapidskills.org"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(user.name)
    end
  end
end
