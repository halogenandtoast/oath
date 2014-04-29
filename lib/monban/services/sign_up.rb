module Monban
  class SignUp
    def initialize user_params
      encrypted_token = token_digest(user_params)
      @user_params = user_params.
        except(token_field).
        merge(token_store_field.to_sym => encrypted_token)
    end

    def perform
      Monban.config.creation_method.call(@user_params.to_hash)
    end

    private

    def token_digest(user_params)
      unencrypted_token = user_params[token_field]
      unless unencrypted_token.empty?
        Monban.encrypt_token(unencrypted_token)
      end
    end

    def token_store_field
      Monban.config.user_token_store_field
    end

    def token_field
      Monban.config.user_token_field
    end
  end
end
