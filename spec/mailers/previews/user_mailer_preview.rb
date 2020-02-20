# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def invite
    UserMailer.with(user: User.first).invite
  end
end
