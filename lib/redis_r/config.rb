# frozen_string_literal: true

require 'singleton'

module RedisR
  # Contain connection config for redis client
  class Config
    include Singleton
    attr_accessor :host, :port, :password, :db

    def host
      @host || 'localhost'
    end

    def port
      @port || 6379
    end

    def db
      @db || 1
    end
  end
end
