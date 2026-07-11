class UserMailer < ApplicationMailer
  def new_user_email
    @user = params[:user]
    @password = params[:password]

    mail to: @user.email, subject: "Bem-vindo ao eRent — credenciais de acesso"
  end

  def reset_password_email
    @user = params[:user]
    @password = params[:password]

    mail to: @user.email, subject: "Recuperação de acesso - eRent"
  end
end
