# frozen_string_literal: true

require "spec_helper"

describe AmplitudeAPI::Identification do
  subject(:identification) { described_class.new(**identification_params) }
  let(:user) {  Struct.new(:id) }

  context "with a user object" do
    let(:identification_params) {  { user_id: user.new(123) } }

    describe "#body" do
      it "populates with the user's id" do
        expect(identification.to_hash[:user_id]).to eq(123)
      end
    end
  end

  context "with a user id" do
    let(:identification_params) {  { user_id: 123 } }

    describe "#body" do
      it "populates with the user's id" do
        expect(identification.to_hash[:user_id]).to eq(123)
      end

      it "includes the device id" do
        identification = described_class.new(user_id: 123, device_id: "abc")
        expect(identification.to_hash[:device_id]).to eq("abc")
      end

      it "includes arbitrary user properties" do
        identification = described_class.new(
          user_id: 123,
          user_properties: {
            first_name: "John",
            last_name: "Doe"
          }
        )
        expect(identification.to_hash[:user_properties]).to eq(first_name: "John", last_name: "Doe")
      end

      context "with country data" do
        let(:identification_params) { { user_id: 123, country: 'GB', region: 'Sussex', city: 'Lewes', dma: nil } }

        it "includes country data" do
          expect(identification.to_hash[:country]).to eq('GB')
        end

        it "includes region data" do
          expect(identification.to_hash[:region]).to eq('Sussex')
        end

        it "includes city data" do
          expect(identification.to_hash[:city]).to eq('Lewes')
        end

        it "includes dma data" do
          expect(identification.to_hash[:dma]).to eq('')
        end
      end
    end
  end

  context "without a user" do
    let(:identification_params) {  { user_id: nil } }

    describe "#body" do
      it "populates with the unknown user" do
        expect(identification.to_hash[:user_id]).to eq(AmplitudeAPI::USER_WITH_NO_ACCOUNT)
      end
    end
  end
end
