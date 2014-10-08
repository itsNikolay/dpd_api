require 'spec_helper'

describe DpdApi do
  let(:client_key)    { '123' }
  let(:client_number) { '234' }
  let(:base_url)      { 'http://wstest.dpd.ru' }
  let(:auth_params) do
    {
      auth: {
        client_number: client_number,
        client_key:    client_key
      }
    }
  end
  let(:configuration) { described_class.configuration }

  it ".configuration" do
    expect(configuration.client_key).to eq    client_key
    expect(configuration.client_number).to eq client_number
    expect(configuration.base_url).to eq      base_url
    expect(configuration.auth_params).to eq   auth_params
  end
end
