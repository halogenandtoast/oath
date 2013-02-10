class User < ActiveRecord::Base
<% if !config[:use_strong_parameters] -%>
  attr_accessible :email, :password_digest
<% elsif Gem::Version.new(Rails.version) < Gem::Version.new('4') -%>
  include ActiveModel::ForbiddenAttributesProtection
<% end -%>
end
