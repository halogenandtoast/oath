module Monban
  class FieldMap
    def initialize params, field_map
      @params = params
      @field_map = field_map
    end

    def to_fields
      if @field_map
        params_from_field_map
      else
        @params
      end
    end

    private

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
