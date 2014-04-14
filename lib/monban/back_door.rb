module Monban
  class BackDoor
    def initialize(app)
      @app = app
    end

    def call(env)
      sign_in_through_the_back_door(env)
      @app.call(env)
    end

    private

    def sign_in_through_the_back_door(env)
      params = Rack::Utils.parse_query(env['QUERY_STRING'])
      user_id = params['as']

      if user_id.present?
        user = Monban.user_class.find(user_id)
        env["warden"].set_user(user)
      end
    end
  end
end
