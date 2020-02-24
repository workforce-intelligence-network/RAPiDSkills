class UserMailerPreview < ActionMailer::Preview
  def invite
    UserMailer.with(user: User.first).invite
  end
end 