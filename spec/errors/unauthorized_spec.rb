require 'spec_helper'
require 'yt/errors/unauthorized'

describe Yt::Errors::Unauthorized do
  let(:msg) { %r{^A request to YouTube API was sent without a valid authentication} }

  describe '#exception' do
    it { expect{raise Yt::Errors::Unauthorized}.to raise_error msg }

    context 'when debugging, and without client_id or api_key' do
      before do
        Yt.configure do |config|
          config.client_id = nil
          config.api_key = nil
          config.log_level = 'debug'
        end
      end

      msg = %r{you need to register your app}
      it { expect{raise Yt::Errors::Unauthorized}.to raise_error msg }
    end
  end
end
