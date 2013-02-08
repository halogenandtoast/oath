require "monban/strategies/password_strategy"

Warden::Manager.serialize_into_session do |user|
  user.id
end

Warden::Manager.serialize_from_session do |id|
  User.find(id)
end

Warden::Strategies.add(:password_strategy, Monban::Strategies::PasswordStrategy)
