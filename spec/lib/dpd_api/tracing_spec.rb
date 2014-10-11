# encoding: utf-8

require "spec_helper"

describe DpdApi::Order do
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
  let(:message) { auth.clone.deep_merge!({ request: params }) }

  # TODO: Add
  xcontext ".states_by_client_order" do
    let(:fixture) { File.read("spec/fixtures/dpd_api/tracing/states_by_client_order.xml") }
    let(:params) do
    end

    it "is success" do
      savon.expects(:get_states_by_client_order).with(message: message).returns(fixture)

      response = described_class.states_by_client_order(params)
      expect(response.first).to have_key(:parcel_status)
    end
  end

  # TODO: Add
  xcontext ".states_by_client_parcel" do
    let(:fixture) { File.read("spec/fixtures/dpd_api/tracing/states_by_client_parcel.xml") }
    let(:params) do
    end

    it "is success" do
      savon.expects(:get_states_by_client_parcel).with(message: message).returns(fixture)

      response = described_class.states_by_client_parcel(params)
      expect(response.first).to have_key(:parcel_status)
    end
  end

  # TODO: Add
  xcontext ".states_by_dpd_order" do
    let(:fixture) { File.read("spec/fixtures/dpd_api/tracing/states_by_dpd_order.xml") }
    let(:params) do
    end

    it "is success" do
      savon.expects(:get_states_by_dpd_order).with(message: message).returns(fixture)

      response = described_class.states_by_dpd_order(params)
      expect(response.first).to have_key(:parcel_status)
    end
  end
end
