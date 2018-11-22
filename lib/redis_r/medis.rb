# frozen_string_literal: true

require 'oj'
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
        if config.url
          Redis.new(url: config.url)
        elsif config.password
          Redis.new(host: config.host, port: config.port, db: config.db, password: config.password)
        else
          Redis.new(host: config.host, port: config.port, db: config.db)
        end
    end

    # Only support attribute type string or string array
    # TODO - support integer, date, datetime
    def set(obj, key, *fields)
      if obj.is_a?(String)
        hmset_params = [key, fields[0], obj]
      elsif obj.is_a?(Array)
        hmset_params = [key, fields[0], Oj.dump(obj)]
      else
        hmset_params = [key]
        fields.each do |field|
          raw_value = obj.__send__(field)
          value = raw_value.is_a?(Array) ? Oj.dump(raw_value) : raw_value
          hmset_params << field
          hmset_params << value
        end
      end

      @redis.hmset hmset_params
    end

    # only return string or array of string
    def get(key, attr, vtype = :string)
      value = @redis.hmget(key, attr).first
      case vtype
      when :array
        value = Oj.load(value)
      end

      value
    end

    # get value if not
    # set value with key, attr
    # when set value is block
    def fetch(key, attr, vtype = :string)
      value = get(key, attr, vtype)
      unless value
        value = yield
        set value, key, attr if value
      end

      value
    end
  end
end
