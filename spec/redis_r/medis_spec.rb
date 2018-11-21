# frozen_string_literal: true

RSpec.describe RedisR::Medis do
  before do
    RedisR::Medis.setup do |config|
      config.host = 'localhost'
      config.port = 6379
      config.db = 1
      config.password = nil
    end

    @client = RedisR::Medis.instance
    @redis = @client.redis
  end

  describe "#initialize" do
    it "init medis by url" do
      RedisR::Medis.setup do |config|
        config.url = 'redis://localhost:6379/1'
      end

      client = RedisR::Medis.instance
      expect(client.redis.hmset 'k1', 'kk1', 'test').to eq('OK')
    end
  end

  describe '#set' do
    before do
      @key = 'set_a_string_value'
      # delete all test key
      @redis.del 'set_a_string_value'
    end

    it 'set object with a string attribute' do
      obj = double
      allow(obj).to receive(:name) { 'redis raw' }
      expect(@client.set(obj, @key, 'name')).to eq('OK')
      expect(@client.redis.hmget(@key, 'name').first).to eq('redis raw')
    end

    it 'set object with a array of attribute' do
      obj = double
      allow(obj).to receive(:name) { ['raw1', 'raw2'] } # rubocop:disable Style/WordArray, Metrics/LineLength

      expect(@client.set(obj, @key, 'name')).to eq('OK')

      expect(@client.redis.hmget(@key, 'name').first).to eq("[\"raw1\",\"raw2\"]") # rubocop:disable Style/StringLiterals, Metrics/LineLength
    end

    it 'set a string value' do
      obj = 'redis raw'
      expect(@client.set(obj, @key, 'name')).to eq('OK')
      expect(@client.redis.hmget(@key, 'name').first).to eq('redis raw')
    end
  end

  describe '#get' do
    before do
      # delete all test key
      @redis.del 'rr'
    end

    it 'value is string' do
      @redis.hmset 'rr', 'k1', 'v1'

      expect(@client.get('rr', 'k1')).to eq('v1')
    end

    it 'value is array' do
      # Style/StringLiterals, Style/WordArray
      @redis.hmset 'rr', 'k1', "[\"raw1\",\"raw2\"]" # rubocop:disable Style/StringLiterals, Metrics/LineLength

      expect(@client.get('rr', 'k1')).to eq(['raw1', 'raw2']) # rubocop:disable Style/WordArray, Metrics/LineLength
    end

    it 'value is nil' do
      @redis.hmset 'rr', 'k1', 'v1'

      expect(@client.get('rr', 'k2')).to eq(nil)
    end
  end

  describe '#fetch' do
    before do
      # delete all test key
      @redis.del 'rr'
    end

    it 'value is string' do
      @redis.hmset 'rr', 'k1', 'v1'

      expect(@client.fetch('rr', 'k1')).to eq('v1')
    end

    it 'value is nil' do
      @redis.hmset 'rr', 'k1', 'v1'

      expect(
        @client.fetch('rr', 'k2') do
          'v2'
        end
      ).to eq('v2')

      expect(@redis.hmget('rr', 'k2')).to eq(['v2'])
    end
  end
end
