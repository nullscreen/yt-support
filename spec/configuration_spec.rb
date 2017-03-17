require 'spec_helper'

describe Yt::Configuration do
  subject(:config) { Yt::Configuration.new }

  describe '#client_id' do
    context 'without an environment variable YT_CLIENT_ID' do
      before { ENV['YT_CLIENT_ID'] = nil }
      it {expect(config.client_id).to be_nil }
    end

    context 'given an environment variable YT_CLIENT_ID' do
      let(:client_id) { '1234567890.apps.googleusercontent.com' }
      before { ENV['YT_CLIENT_ID'] = client_id}
      it {expect(config.client_id).to eq client_id }
    end
  end

  describe '#client_secret' do
    context 'without an environment variable YT_CLIENT_SECRET' do
      before { ENV['YT_CLIENT_SECRET'] = nil }
      it {expect(config.client_secret).to be_nil }
    end

    context 'given an environment variable YT_CLIENT_SECRET' do
      let(:client_secret) { '1234567890' }
      before { ENV['YT_CLIENT_SECRET'] = client_secret}
      it {expect(config.client_secret).to eq client_secret }
    end
  end

  describe '#api_key' do
    context 'without an environment variable YT_API_KEY' do
      before { ENV['YT_API_KEY'] = nil }
      it {expect(config.api_key).to be_nil }
    end

    context 'given an environment variable YT_API_KEY' do
      let(:api_key) { '123456789012345678901234567890' }
      before { ENV['YT_API_KEY'] = api_key}
      it {expect(config.api_key).to eq api_key }
    end
  end

  describe 'developing?' do
    context 'with YT_LOG_LEVEL not set to devel' do
      before { ENV['YT_LOG_LEVEL'] = nil }
      it {expect(config).not_to be_developing }
    end

    context 'with YT_LOG_LEVEL set to devel' do
      before { ENV['YT_LOG_LEVEL'] = 'devel' }
      it {expect(config).to be_developing }
    end
  end

  describe 'debugging?' do
    context 'with YT_LOG_LEVEL not set to devel or debug' do
      before { ENV['YT_LOG_LEVEL'] = nil }
      it {expect(config).not_to be_debugging }
    end

    context 'with YT_LOG_LEVEL set to devel or debug' do
      before { ENV['YT_LOG_LEVEL'] = %w(devel debug).sample }
      it {expect(config).to be_debugging }
    end
  end
end