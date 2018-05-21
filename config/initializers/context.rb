# frozen_string_literal: true

require 'singleton'

class Context
  include Singleton

  attr_reader :repositories

  def initialize
    @repositories = {}
  end

  def self.register_repository(key:, repository:)
    instance.repositories[key] = repository
  end

  def self.repository(key:)
    instance.repositories[key]
  end
end
