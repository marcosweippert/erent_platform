class PasswordChangesController < ApplicationController
  layout 'authentication'
  skip_before_action :require_password_change

  def edit
  end

  def update
    if current_user.update(password_change_params.merge(must_change_password: false))
      redirect_to root_path, notice: "Senha atualizada com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def password_change_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
