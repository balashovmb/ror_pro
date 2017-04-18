class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_attachment, only: :destroy

  respond_to :js

  def destroy
    respond_with(@attachment.destroy) if current_user.author?(@attachment.attachable)
  end

  private

  def set_attachment
    @attachment = Attachment.find(attachment_params)
  end

  def attachment_params
    params.require(:id)
  end
end
