class ApplicationController < ActionController::Base
  before_action :require_login
  before_action :require_password_change

  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    return if logged_in?

    redirect_to new_session_path, alert: "É preciso entrar para acessar esta página."
  end

  def require_password_change
    return unless logged_in?
    return unless current_user.must_change_password?
    return if controller_name == 'password_changes'

    redirect_to edit_password_change_path, alert: "Por favor redefina sua senha antes de continuar."
  end

  def require_master
    return if User.none? && %i[new create].include?(action_name.to_sym)
    return if logged_in? && current_user.master?

    redirect_to root_path, alert: "Acesso negado. Somente usuário master pode realizar esta ação."
  end

  def require_owner_or_master(user)
    return if logged_in? && (current_user.master? || current_user == user)

    redirect_to root_path, alert: "Acesso negado."
  end
end
