class User < ActiveRecord::Base
<% if !config[:use_strong_parameters] -%>
  attr_accessible :email, :password_digest
<% elsif Gem::Version.new(Rails.version).segments[0] < 4 -%>
  include ActiveModel::ForbiddenAttributesProtection
<% end -%>
end
