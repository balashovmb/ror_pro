class PagesController < ApplicationController
  skip_authorization_check

  def terms; end

  def policy; end
end