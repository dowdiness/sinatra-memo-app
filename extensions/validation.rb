require "dry-validation"

module Sinatra
  module Validation
    class InvalidParameterError < StandardError
      attr_reader :result

      def initialize(result)
        @result = result
      end
    end

    class Result
      attr_reader :params, :messages

      def initialize(params)
        @params = params
      end

      def with_message(errors)
        @messages = errors.to_h.map { |key, message| "#{key.to_s} #{message.first}" }
        self
      end
    end

    module Helpers
      def validates(&block)
        schema = Class.new(Dry::Validation::Contract, &block).new
        validation = schema.call(params)
        result = Result.new(Sinatra::IndifferentHash[validation.to_h])
          .with_message(validation.errors)

        if validation.failure?
          raise InvalidParameterError.new(result)
        end

        result
      rescue InvalidParameterError => exception
        raise exception
      end
    end

  end
  helpers Validation::Helpers
end
