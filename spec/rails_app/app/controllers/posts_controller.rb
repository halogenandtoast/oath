class PostsController < ApplicationController
  before_filter :require_login

  def index
    render nothing: true
  end
end
