class PagesController < ApplicationController
  skip_authorization_check

  def terms; 
    ahoy.track "terms page event"
  end

  def policy; end
end
