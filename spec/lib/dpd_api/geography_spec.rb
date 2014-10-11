# encoding: utf-8

require "spec_helper"

describe DpdApi::Geography do
  include Savon::SpecHelper
  before(:all) { savon.mock!   }
  after(:all)  { savon.unmock! }

  let(:auth) do
    { request: {
      auth: {
        client_number: "234",
        client_key:    "123"
      } } }
  end
  let(:message) { auth }

  context ".cities_cash_pay" do
    let(:fixture) { File.read("spec/fixtures/dpd_api/geography/cities_cash_pay.xml") }

    it "is success" do
      savon.expects(:get_cities_cash_pay).with(message: message).returns(fixture)

      response = described_class.cities_cash_pay
      expect(response.first).to have_key(:city_id)
      expect(response.first).to have_key(:country_code)
      expect(response.first).to have_key(:region_code)
      expect(response.first).to have_key(:region_name)
      expect(response.first).to have_key(:city_name)
    end
  end

  context ".terminals_self_delivery" do
    let(:fixture) { File.read("spec/fixtures/dpd_api/geography/terminals_self_delivery.xml") }

    it "is success" do
      savon.expects(:get_terminals_self_delivery2).with(message: message).returns(fixture)

      response = described_class.terminals_self_delivery
      expect(response.first).to have_key(:terminal)
    end
  end

  context ".parcel_shops" do
    let(:fixture) { File.read("spec/fixtures/dpd_api/geography/parcel_shops.xml") }

    it "is success" do
      savon.expects(:get_parcel_shops).with(message: message).returns(fixture)

      response = described_class.parcel_shops
      expect(response.first).to have_key(:parcel_shop)
    end
  end
end
