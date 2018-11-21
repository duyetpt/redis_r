# frozen_string_literal: true

require 'json'
require 'singleton'
require 'redis'

module RedisR
  class Medis
    include Singleton
    attr_accessor :redis

    def self.setup
      yield(Config.instance)
    end

    def initialize
      config = Config.instance
      @redis =
        if config.password
          Redis.new(host: config.host, port: config.port, db: config.db, password: config.password)
        else
          Redis.new(host: config.host, port: config.port, db: config.db)
        end
    end

    # Only support attribute type string or string array
    # TODO - support integer, date, datetime
    def set(obj, key, *attrs)
      hmset_params = [key]
      if obj.is_a? String
        hmset_params << attrs[0]
        hmset_params << obj
      else
        attrs.each do |attr|
          raw_value = obj.__send__(attr)
          value = raw_value.is_a?(Array) ? raw_value.to_json : raw_value
          hmset_params << attr
          hmset_params << value
        end
      end

      @redis.hmset hmset_params
    end

    # only return string or array of string
    def get(key, attr)
      value = @redis.hmget(key, attr).first
      begin
        value = JSON.parse(value)
      rescue StandardError => exception
        # when value is string or primitive
      end

      value
    end

    # get value if not
    # set value with key, attr
    # when set value is block
    def fetch(key, attr)
      value = get(key, attr)
      unless value
        value = yield
        set value, key, attr
      end

      value
    end
  end
end
