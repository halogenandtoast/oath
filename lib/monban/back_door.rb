module Monban
  # Middleware used in tests to allow users to be signed in directly, without
  # having to load and submit the sign in form. The user should be provided by
  # using the key :as in a hash passed to the path.
  #
  # @note This should only be used for testing purposes
  # @since 0.0.15
  # @example Using the backdoor in an rspec feature spec
  #   feature "User dashboard" do
  #     scenario "user visits dashboard" do
  #       user = create(:user)
  #       visit dashboard_path(as: user)
  #       expect(page).to have_css("#dashboard")
  #     end
  #   end
  class BackDoor
    # Create the a new BackDoor middleware for test purposes
    # @return [BackDoor]
    def initialize(app)
      @app = app
    end

    # Execute the BackDoor middleware signing in the user specified with :as
    def call(env)
      sign_in_through_the_back_door(env)
      @app.call(env)
    end

    private

    def sign_in_through_the_back_door(env)
      params = Rack::Utils.parse_query(env['QUERY_STRING'])
      user_id = params['as']

      if user_id.present?
        user = Monban.config.user_class.find(user_id)
        env["warden"].set_user(user)
      end
    end
  end
end
