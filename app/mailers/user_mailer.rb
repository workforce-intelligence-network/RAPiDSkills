class UserMailer < ApplicationMailer
  def invite
    @user = params[:user]
    @subject = "You're invited to sign up for RapidSkills!"
    mail(to: @user.email, subject: @subject, content_type: 'text/plain') do |format|
      format.text 
    end
  end
end 