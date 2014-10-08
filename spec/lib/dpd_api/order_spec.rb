require "spec_helper"

describe DpdApi::Order do
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

  context "#create_order" do
    let(:fixture) { File.read("spec/fixtures/dpd_api/order/create_order.xml") }
    let(:params) do
      {
        header: {
          date_pickup: Date.today.to_s,
          sender_address: {
            name: 'Иванов Иван Иваныч',
            terminal_code: 'ABA',
            city: 'Москва',
            street: 'Ленина',
            street_abbr: 'ул',
            house: 1,
            contact_fio: 'Иванов Иван Иваныч',
            contact_phone: '+79211234567',
          },
        },
        order: [
          {
            order_number_internal: '1234567',
            service_code: 'TEN',
            service_variant: 'ТД',
            cargo_num_pack: '1',
            cargo_weight: '1',
            cargo_registered: false,
            cargo_category: 'Одежда',
            receiver_address: {
              name: 'Петр Петров Петрович',
              terminal_code: '',
              city: 'Воронеж',
              street: 'Красноармейская',
              street_abbr: 'ул',
              house: 1,
              contact_fio: 'Иванов Иван Иваныч',
              contact_phone: '+79211234567',
            },
            parcel: [
              {
                number: '123456789',
              },
            ],
          },
        ],
      }
    end

    it "is success" do
      savon.expects(:create_order).with(message: message).returns(fixture)

      response = service.create_order(params)
      expect(response.first).to have_key(:order_number_internal)
      expect(response.first).to have_key(:status)
      expect(response.first).to have_key(:error_message)
    end
  end

  context "#cancel_order" do
    let(:fixture) { File.read("spec/fixtures/dpd_api/order/cancel_order.xml") }
    let(:params) do
      { cancel: {
        order_num_internal: '1234567',
      }, }
    end

    it "is success" do
      savon.expects(:cancel_order).with(message: message).returns(fixture)

      response = service.cancel_order(params)
      expect(response.first).to have_key(:order_number_internal)
      expect(response.first).to have_key(:status)
    end
  end

  context "#order_status" do
    let(:fixture) { File.read("spec/fixtures/dpd_api/order/order_status.xml") }
    let(:params) do
      { order: {
        order_number_internal: '1234567',
      } }
    end

    it "is success" do
      savon.expects(:get_order_status).with(message: message).returns(fixture)

      response = service.order_status(params)
      expect(response.first).to have_key(:order_number_internal)
      expect(response.first).to have_key(:status)
      expect(response.first).to have_key(:error_message)
    end
  end

  context "#create_address" do
    let(:fixture) { File.read("spec/fixtures/dpd_api/order/create_address.xml") }
    let(:params) do
      { client_address: {
        code: '78',
        name: 'Перт Петров Петрович',
        city: 'Воронеж',
        street: 'Красноармейская',
        street_abbr: 'ул',
        house: 1,
        contact_fio: 'Перт Петров Петрович',
        contact_phone: '+79211234567',
      } }
    end

    it "is success" do
      savon.expects(:create_address).with(message: message).returns(fixture)

      response = service.create_address(params)
      expect(response.first).to have_key(:code)
      expect(response.first).to have_key(:status)
    end
  end

  context "#update_address" do
    let(:fixture) { File.read("spec/fixtures/dpd_api/order/update_address.xml") }
    let(:params) do
      { client_address: {
        code: '78',
        name: 'Перт Петров Петрович',
        city: 'Владивосток',
        street: 'Набережная',
        street_abbr: 'ул',
        house: 1,
        contact_fio: 'Перт Петров Петрович',
        contact_phone: '+79211234567',
      } }
    end

    it "is success" do
      savon.expects(:update_address).with(message: message).returns(fixture)

      response = service.update_address(params)
      expect(response.first).to have_key(:code)
      expect(response.first).to have_key(:status)
    end
  end

  # TODO: just fill with response the invoice_file.xml file and test should pass
  xcontext "#invoice_file" do
    let(:fixture) { File.read("spec/fixtures/dpd_api/order/invoice_file.xml") }
    let(:params) do
      { order_num: '1234567', }
    end

    it "is success" do
      savon.expects(:get_invoice_file).with(message: message).returns(fixture)

      response = service.invoice_file(params)
      expect(response.first).to have_key(:file)
    end
  end

  # TODO: just fill with response the add_parcels.xml file and test should pass
  xcontext "#add_parcels" do
    let(:fixture) { File.read("spec/fixtures/dpd_api/order/add_parcels.xml") }
    let(:params) do
    end

    it "is success" do
      savon.expects(:add_parcels).with(message: message).returns(fixture)

      response = service.add_parcels(params)
      expect(response.first).to have_key(:parcel_status)
      expect(response.first).to have_key(:status)
    end
  end

  # TODO: just fill with response the add_parcels.xml file and test should pass
  xcontext "#remove_parcels" do
    let(:fixture) { File.read("spec/fixtures/dpd_api/order/remove_parcels.xml") }
    let(:params) do
    end

    it "is success" do
      savon.expects(:remove_parcels).with(message: message).returns(fixture)

      response = service.remove_parcels(params)
      expect(response.first).to have_key(:parcel_status)
      expect(response.first).to have_key(:status)
    end
  end
end
