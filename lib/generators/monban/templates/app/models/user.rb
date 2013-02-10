class User < ActiveRecord::Base
<% unless config[:use_strong_parametes] -%>
  attr_accessible :email, :password_digest
<% end -%>
end
