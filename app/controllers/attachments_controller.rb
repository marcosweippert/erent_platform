class AttachmentsController < ApplicationController
  def destroy
    attachment = ActiveStorage::Attachment.find(params[:id])
    attachment.purge
    redirect_back fallback_location: root_path, notice: "Arquivo excluído."
  end
end