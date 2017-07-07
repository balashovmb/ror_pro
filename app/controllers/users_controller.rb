class UsersController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  respond_to :js

  def subscribe_digest
    current_user.subscribe_digest
  end

  def unsubscribe_digest
    current_user.unsubscribe_digest
  end
end
