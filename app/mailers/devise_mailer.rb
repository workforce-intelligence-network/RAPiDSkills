class DeviseMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer' 
  

end 