class SessionsController < ApplicationController
  layout 'authentication', only: %i[new]
  skip_before_action :require_login, only: %i[new create]
  skip_before_action :require_password_change, only: %i[new create]

  def new
  end

  def create
    user = User.find_by(email: session_params[:email].to_s.downcase)

    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      redirect_to user.must_change_password? ? edit_password_change_path : root_path, notice: "Login realizado com sucesso."
    else
      flash.now[:alert] = "Email ou senha inválidos."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to new_session_path, notice: "Logout realizado com sucesso."
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
