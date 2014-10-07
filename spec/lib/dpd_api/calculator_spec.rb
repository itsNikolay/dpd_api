require "spec_helper"

describe DpdApi::Calculator do
  include Savon::SpecHelper
  before(:all) { savon.mock!   }
  after(:all)  { savon.unmock! }

  let(:service) { described_class.new }
  let(:auth) do
    { request: {
      auth: {
        client_number: "234",
        client_key:    "123"
      } } }
  end
  let(:message) { auth.clone.deep_merge!({ request: params }) }

  context "#service_cost" do
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

      response = service.service_cost(params)
      expect(response.first).to have_key(:service_code) # 'TEN'
      expect(response.first).to have_key(:service_name) # 'DPD 10:00'
      expect(response.first).to have_key(:cost)         # '551.65'
      expect(response.first).to have_key(:days)         # '4'
    end
  end

  context "#serivce_cost" do
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

      response = service.service_cost(params)
      expect(response).to have_key(:errors)
    end
  end
end
