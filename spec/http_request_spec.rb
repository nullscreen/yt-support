require 'spec_helper'

describe 'Yt::HTTPRequest#run' do
  context 'given a valid GET request to a YouTube JSON API' do
    path = '/discovery/v1/apis/youtube/v3/rest'
    headers = {'User-Agent' => 'Yt::HTTPRequest'}
    params = {verbose: 1}
    request = Yt::HTTPRequest.new path: path, headers: headers, params: params

    it 'returns the HTTP response with the JSON-parsed body' do
      response = request.run
      expect(response).to be_a Net::HTTPOK
      expect(response.body).to be_a Hash
    end

    it 'instruments when ActiveSupport::Notifications are around' do
      fake_notifier_klass = Class.new do
        attr_reader :label, :data
        def instrument(label, data)
          @label = label
          @data = data
          yield data
        end
      end
      fake_notifier = fake_notifier_klass.new
      stub_const("ActiveSupport::Notifications", fake_notifier)

      response = request.run

      expect(fake_notifier.label).to eql('request.yt')
      expect(fake_notifier.data[:method]).to eql('GET')
      expect(fake_notifier.data[:request].path).to eql('/discovery/v1/apis/youtube/v3/rest?verbose=1')
      expect(fake_notifier.data[:request_uri].to_s).to eql('https://www.googleapis.com/discovery/v1/apis/youtube/v3/rest?verbose=1')
      expect(fake_notifier.data[:response].code).to eql("200")
    end
  end

  context 'when developing' do
    path = '/discovery/v1/apis/youtube/v3/rest'
    headers = {'User-Agent' => 'Yt::HTTPRequest'}
    params = {verbose: 1}
    request = Yt::HTTPRequest.new path: path, headers: headers, params: params

    before { Yt.configuration.log_level = :devel }
    after  { Yt.configuration.log_level = :debug }

    it 'outputs the request in curl format' do
      p "LEVEL #{Yt.configuration.log_level}"
      expect(STDOUT).to receive(:puts).with <<-MSG.tr("\n", " ").strip
curl
-X GET
-H "content-type: application/json"
-H "user-agent: Yt::HTTPRequest"
"https://www.googleapis.com/discovery/v1/apis/youtube/v3/rest?verbose=1"
      MSG
      request.run
    end
  end

  context 'given a invalid request to a YouTube JSON API' do
    path = '/discovery/v1/apis/youtube/v3/unknown-endpoint'
    body = {token: :unknown}
    request = Yt::HTTPRequest.new path: path, method: :post, body: body

    it 'raises an HTTPError' do
      expect{request.run}.to raise_error Yt::HTTPError, 'Error: Not Found'
    end
  end

  context 'given a POST request with x-www-form-urlencoded body' do
    host = 'accounts.google.com'
    path = '/o/oauth2/token'
    body = {client_id: :unknown}
    options = {host: host, path: path, body: body, request_format: :form}
    request = Yt::HTTPRequest.new options

    it 'raises an HTTPError' do
      expect{request.run}.to raise_error Yt::HTTPError
    end
  end

  context 'given a request that causes a connection/server error' do
    host = 'g00gl3ap1s.com'
    request = Yt::HTTPRequest.new host: host

    it 'raises an HTTPError' do
      expect{request.run}.to raise_error Yt::ConnectionError
    end
  end
end
