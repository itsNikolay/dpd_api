require 'spec_helper'

describe DpdApi do
  let(:client_key)    { '123' }
  let(:client_number) { '234' }
  let(:base_url)      { 'http://example.com' }
  let(:auth_params) do
    {
      auth: {
        client_number: client_number,
        client_key:    client_key
      }
    }
  end

  before do
    described_class.configure do |config|
      config.client_key    = client_key
      config.client_number = client_number
      config.base_url      = base_url
    end
  end

  it ".configuration" do
    configuration = described_class.configuration

    expect(configuration.client_key).to eq    client_key
    expect(configuration.client_number).to eq client_number
    expect(configuration.base_url).to eq      base_url
    expect(configuration.auth_params).to eq   auth_params
  end
end
