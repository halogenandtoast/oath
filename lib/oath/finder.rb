module Oath
  # Thin delegator that exposes the configured user class through Oath. It
  # lets applications, console helpers and constraints reach the model's
  # finders and scopes without ever referencing the concrete class, which
  # keeps Oath decoupled from whichever ORM the host application chose.
  #
  # Any message the delegator does not define itself is relayed to the user
  # class, so model scopes are available as ordinary method calls:
  #
  # @example Looking a user up
  #   Oath::Finder.new.find_by(email: "ada@example.com")
  #
  # @example Reaching a model scope
  #   Oath::Finder.new.active
  #
  # @since 1.2.0
  class Finder
    # @param model [Class] the class to delegate to. Defaults to the
    #   configured user class.
    def initialize(model = Oath.config.user_class)
      @model = model
    end

    # Mirrors the delegate so duck-typing and +respond_to?+ checks keep
    # working through the proxy.
    def respond_to_missing?(name, include_private = false)
      @model.respond_to?(name, include_private)
    end

    private

    def method_missing(name, *args, &block)
      @model.send(name, *args, &block)
    end
  end
end
