# encoding: utf-8

require "spec_helper"

describe DpdApi::Calculator do
  include Savon::SpecHelper
  before(:all) { savon.mock!   }
  after(:all)  { savon.unmock! }

  let(:auth) do
    { request: {
      auth: {
        client_number: ENV['DPD_CLIENT_NUMBER'] || '234',
        client_key:    ENV['DPD_CLIENT_KEY']    || '123'
      } } }
  end
  let(:message) { auth.clone.deep_merge!({ request: params }) }

  context ".service_cost" do
    let(:fixture) { File.read("spec/fixtures/dpd_api/calculator/service_cost.xml") }
    let(:params) do
      { pickup:   { city_id: 195851995 },
        delivery: { city_id: 48951627 },
        self_pickup:   false,
        self_delivery: false,
        weight: 1, }
    end

    it "is success" do
      savon.expects(:get_service_cost2).with(message: message).returns(fixture)

      response = described_class.service_cost(params)
      expect(response.first).to have_key(:service_code) # 'TEN'
      expect(response.first).to have_key(:service_name) # 'DPD 10:00'
      expect(response.first).to have_key(:cost)         # '551.65'
      expect(response.first).to have_key(:days)         # '4'
    end
  end

  context ".serivce_cost" do
    let(:fixture) { File.read("spec/fixtures/dpd_api/calculator/service_cost_fault.xml") }
    let(:params) do
      { pickup:   { city_id: '0' },
        delivery: { city_id: '0' },
        self_pickup:   false,
        self_delivery: false,
        weight: 1, }
    end

    it "is fault" do
      savon.expects(:get_service_cost2).with(message: message).returns(fixture)

      response = described_class.service_cost(params)
      expect(response).to have_key(:errors)
    end
  end

  context ".service_cost_by_parcels" do
    let(:fixture) { File.read("spec/fixtures/dpd_api/calculator/service_cost_by_parcels.xml") }
    let(:params) do
      { pickup:   { city_id: 195851995 },
        delivery: { city_id: 48951627 },
        self_pickup:   true,
        self_delivery: true,
        parcel: {
          weight: 0.5,
          length: 0.5,
          width:  0.5,
          height: 0.5,
        },
        parcel: {
          weight: 1,
          length: 1,
          width:  1,
          height: 1,
        } }
    end

    it "is success" do
      savon.expects(:get_service_cost_by_parcels2).with(message: message).returns(fixture)

      response = described_class.service_cost_by_parcels(params)
      expect(response.first).to have_key(:service_code)
      expect(response.first).to have_key(:service_name)
      expect(response.first).to have_key(:cost)
      expect(response.first).to have_key(:days)
    end
  end

  context ".service_cost_by_parcels" do
    let(:fixture) { File.read("spec/fixtures/dpd_api/calculator/service_cost_by_parcels_fault.xml") }
    let(:params) { { pickup: { city_id: 0 } } }

    it "is fails" do
      savon.expects(:get_service_cost_by_parcels2).with(message: message).returns(fixture)

      response = described_class.service_cost_by_parcels(params)
      expect(response).to have_key(:errors)
    end
  end
end
