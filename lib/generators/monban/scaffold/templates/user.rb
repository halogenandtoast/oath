class User < ActiveRecord::Base<% unless @using_strong_parameters %>
  attr_accessible :email, :password_digest
<% end %>end
