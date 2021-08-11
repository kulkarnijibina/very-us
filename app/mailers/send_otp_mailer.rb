# frozen_string_literal: true

class SendOtpMailer < ApplicationMailer
  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_otp(user)
    @user = user
    mail(to: @user.email,
         subject: 'Reset password instructions')
  end

  def send_verification_otp(user)
    @user = user
    mail(to: @user.email,
         subject: 'Verification OTP')
  end
end
