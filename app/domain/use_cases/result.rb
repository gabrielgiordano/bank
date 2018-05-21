# frozen_string_literal: true

module UseCases
  class Result
    attr_reader :errors, :data

    def self.success(data: nil)
      new(status: :success, data: data)
    end

    def self.failure(errors: nil)
      new(status: :failure, errors: errors)
    end

    def initialize(status:, data: nil, errors: [])
      @status = status
      @data = data
      @errors = errors
    end

    def success?
      @status == :success
    end

    def failure?
      @status != :success
    end
  end
end
