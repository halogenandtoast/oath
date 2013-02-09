module Monban
  class SignUp
    def initialize user_params
      unencrypted_password = user_params.delete(password_field)
      password_digest = Monban.encrypt_password(unencrypted_password)
      @user_params = user_params.merge(password_digest: password_digest)
    end

    def perform
      Monban.user_class.create(@user_params.to_hash)
    end

    private

    def password_field
      Monban.config.user_password_field
    end
  end
end
