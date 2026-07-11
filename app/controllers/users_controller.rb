class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action :require_master, only: %i[index new create]
  before_action :set_user, only: %i[edit update]
  before_action only: %i[edit update] do
    require_owner_or_master(@user)
  end

  def index
    @users = User.order(:name)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(create_user_params)
    @user.master = true if User.none?
    @user.must_change_password = true

    default_password = "Senhas@810"
    @user.password = default_password
    @user.password_confirmation = default_password

    if @user.save
      UserMailer.with(user: @user, password: default_password).new_user_email.deliver_now
      redirect_to users_path, notice: "Usuário criado com sucesso. Credenciais enviadas por email."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(update_user_params)
      redirect_to users_path, notice: "Usuário atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def create_user_params
    params.require(:user).permit(:name, :email)
  end

  def update_user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
