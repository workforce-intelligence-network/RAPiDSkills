require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "invite" do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.with(user: user).invite }

    it "renders the headers" do
      expect(mail.subject).to match("You're invited to sign up for RapidSkills!")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["info@rapidskillsgenerator.org"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(new_registration_url)
    end
  end
end 