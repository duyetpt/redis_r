# frozen_string_literal: true

RSpec.describe RedisR::Config do
  describe '#host' do
    it 'not config specific host, return default' do
      config = RedisR::Config.instance
      expect(config.host).to eq('localhost')
    end

    it 'host is 192.168.1.1' do
      config = RedisR::Config.instance
      config.host = '192.168.1.1'
      expect(config.host).to eq('192.168.1.1')
    end
  end

  describe '#port' do
    it 'not set specific port, return default' do
      config = RedisR::Config.instance
      expect(config.port).to eq(6379)
    end

    it 'port is 1234' do
      config = RedisR::Config.instance
      config.port = 1234
      expect(config.port).to eq(1234)
    end
  end

  describe '#db' do
    it 'not set specific db, return default' do
      config = RedisR::Config.instance
      expect(config.db).to eq(1)
    end

    it 'db is 3' do
      config = RedisR::Config.instance
      config.db = 3
      expect(config.db).to eq(3)
    end
  end

  describe '#password' do
    it 'not config specific password, return default' do
      config = RedisR::Config.instance
      expect(config.password).to eq(nil)
    end

    it 'password is 12345678' do
      config = RedisR::Config.instance
      config.password = '12345678'
      expect(config.password).to eq('12345678')
    end
  end
end
