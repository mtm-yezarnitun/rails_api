class UserMailer < ApplicationMailer
    default from: 'no-reply@myapp.com'

    def welcome_email(user)
        @user = user 
        mail(to: @user.email, subject: 'welcome to our app !' )
    end
end
