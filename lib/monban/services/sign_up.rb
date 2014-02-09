module Monban
  class SignUp
    def initialize user_params
      unencrypted_token = user_params[token_field]
      token_digest = Monban.encrypt_token(unencrypted_token)
      @user_params = user_params.except(token_field).merge(token_store_field.to_sym => token_digest)
    end

    def perform
      Monban.config.user_creation_method.call(@user_params.to_hash)
    end

    private

    def token_store_field
      Monban.config.user_token_store_field
    end

    def token_field
      Monban.config.user_token_field
    end
  end
end
