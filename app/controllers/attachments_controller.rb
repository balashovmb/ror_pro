class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = Attachment.find(attachment_params)
    @attachment.destroy if current_user.author?(@attachment.attachable)
  end

  private

  def attachment_params
    params.require(:id)
  end
end
