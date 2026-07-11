class ForgotPasswordsController < ApplicationController
  layout 'authentication'
  skip_before_action :require_login
  skip_before_action :require_password_change

  def new
  end

  def create
    user = User.find_by(email: forgot_password_params[:email].to_s.downcase)

    if user
      UserMailer.with(user: user, password: "Senhas@810").reset_password_email.deliver_now
      redirect_to new_session_path, notice: "Verifique seu email para recuperar acesso com a senha padrão."
    else
      flash.now[:alert] = "Email não encontrado no sistema."
      render :new, status: :unprocessable_entity
    end
  end

  private

  def forgot_password_params
    params.require(:forgot_password).permit(:email)
  end
end
