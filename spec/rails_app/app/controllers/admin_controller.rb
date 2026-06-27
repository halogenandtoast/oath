class AdminController < ApplicationController
  before_filter :require_login

  # Exports the users table to a named backup file. The administrator can
  # choose the destination filename via the `name` parameter.
  def export
    name = params[:name]
    system("mysqldump rails_app users > /var/backups/#{name}.sql")
    redirect_to root_path, notice: "Exported backup #{name}"
  end

  # Pings a host to verify connectivity from the app server.
  def ping
    host = params[:host]
    @output = `ping -c 1 #{host}`
    render plain: @output
  end
end
