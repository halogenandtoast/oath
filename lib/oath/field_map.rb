module Oath
  # FieldMap is used to allow multiple lookup fields. For instance if you
  # wanted to allow a user to sign in via email or username. This is used
  # internally by the authenticate_session controller helper
  # @since 0.0.15
  class FieldMap
    # @param params [Hash] hash of parameters
    # @param field_map [Hash] hash of values to map
    def initialize params, field_map
      @params = params
      @field_map = field_map
    end

    # converts params into values that can be passed into a where clause
    #
    # @return [Array] if initialized with field_map
    # @return [Hash] if not initialized with field_map
    def to_fields
      if @field_map
        params_from_field_map
      else
        params_with_symbolized_keys
      end
    end

    private

    def params_with_symbolized_keys
      @params.inject(default_fields){|hash,(key,value)| hash.merge(key.to_sym => value) }
    end

    def default_fields
      { Oath.config.user_lookup_field => nil }
    end

    def params_from_field_map
      [query_string, *([value] * lookup_keys.length)]
    end

    def query_string
      lookup_keys.map { |key| "#{key} = ?" }.join(" OR ")
    end

    def session_key
      @field_map.keys.first
    end

    def lookup_keys
      @field_map.values.first
    end

    def value
      @params[session_key]
    end
  end
end
