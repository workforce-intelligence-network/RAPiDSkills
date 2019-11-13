class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome_email.subject
  #
  def welcome_email(user_id)
    @user = User.find(user_id)

    mail to: @user.email, subject: "Welcome to RAPiDSkills"
  end
end
