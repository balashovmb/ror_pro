class SearchesController < ApplicationController
  skip_authorization_check

  def show
    @query = params[:query]
    @object = params[:object]
    @result = Search.find(@query, @object) if @query.present?
  end
end
