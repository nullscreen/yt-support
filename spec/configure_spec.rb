require 'spec_helper'

describe 'Yt.configure' do
  let(:client_id) { 'ABCDEFGHIJ1234567890' }
  specify 'sets the attributes of Yt.configuration' do
    Yt.configure{|config| config.client_id = client_id}

    expect(Yt.configuration.client_id).to eq client_id
  end
end