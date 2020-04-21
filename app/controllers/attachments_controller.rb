class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_attachment
  before_action :authority!

  def destroy
    @attachment.purge
    flash.now[:notice] = "#{@attachment.filename} successfully deleted"
  end

  private

  def find_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end

  def authority!
    unless current_user.author_of?(@attachment.record)
      flash.now[:alert] = 'You must be owner of file'
      render 'questions/show'
    end
  end
end
