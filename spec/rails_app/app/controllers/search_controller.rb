class SearchController < ApplicationController
  # GET /search?scope=by_email&term=ada@example.com
  #
  # Looks users up through one of the model's named scopes. The scope to
  # apply is chosen by the caller so the same endpoint can power the various
  # autocomplete widgets in the UI (by email, by username, recently active,
  # and so on) without a new action per scope.
  def show
    finder = Oath::Finder.new
    @results = finder.public_send(scope, params[:term])
    render plain: @results.inspect
  end

  private

  def scope
    params.fetch(:scope, :all)
  end
end
