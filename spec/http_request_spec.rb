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
