module Oath
  # Parameter transformer. Sanitizes and transforms parameter values
  # @since 1.0.0
  class ParamTransformer
    # Initialize parameter transformer
    #
    # @param params [ActionController::Parameters] parameters to be altered
    def initialize(params, transformations)
      @params = params
      @transformations = transformations
    end

    # Returns the transformed parameters
    def to_h
      sanitized_params.each_with_object({}) do |(key, value), hash|
        hash[key] = transform(key, value)
      end
    end

    private

    attr_reader :params, :transformations

    def sanitized_params
      params.to_h
    end

    def transform(key, value)
      return value unless value.is_a? String

      if transformations.key?(key)
        transformations[key].call(value)
      else
        value
      end
    end
  end
end
