# frozen_string_literal: true

require "spec_helper"

module SecureHeaders
  describe ReportTo do
    describe "#value" do
      specify { expect(ReportTo.make_header).to eq(nil) }

      specify do
        expect(
          ReportTo.make_header(group: "csp-endpoint", max_age: 10886400, endpoints: [{url: "http://foo.com/bar"}])
        ).to eq(
          [ReportTo::HEADER_NAME, "{\"group\":\"csp-endpoint\",\"max-age\":10886400,\"endpoints\":[{\"url\":\"http://foo.com/bar\"}]}"]
        )
      end

      # specify do
      #   hash_1 = { group: "csp-endpoint", max_age: 10886400, endpoints: [{url: "http://foo.com/bar"}] }
      #   hash_2 = { group: "report-endpoint", max_age: 10886400, endpoints: [{url: "http://bar.com/foo"}] }
      #   json = <<~JSON
      #     {\"group\":\"csp-endpoint\",\"max-age\":10886400,\"endpoints\":[{\"url\":\"http://foo.com/bar\"}]},
      #     {\"group\":\"report-endpoint\",\"max-age\":10886400,\"endpoints\":[{\"url\":\"http://bar.com/foo\"}]}
      #   JSON
      #   expect(
      #     ReportTo.make_header(hash_1, hash_2)
      #   ).to eq(
      #     [ReportTo::HEADER_NAME, json]
      #   )
      # end

      context "invalid values" do
        it "raises an error when the value is not an array" do
          expect do
            ReportTo.validate_config!("foobar")
          end.to raise_error(ReportToConfigError)
        end

        it "raises an error when the value array does not contain hashes" do
          expect do
            ReportTo.validate_config!(["foobar"])
          end.to raise_error(ReportToConfigError)
        end

        it "raises an error when the group key is missing" do
          expect do
            ReportTo.validate_config!({ no_group: "foobar", max_age: 1234, endpoints: [{ url: "http://foo.com" }] })
          end.to raise_error(ReportToConfigError)
        end

        it "raises an error when the max_age key is missing" do
          expect do
            ReportTo.validate_config!({ group: "foobar", no_max_age: 1234, endpoints: [{ url: "http://foo.com" }] })
          end.to raise_error(ReportToConfigError)
        end

        it "raises an error when the endpoints key is missing" do
          expect do
            ReportTo.validate_config!({ group: "foobar", max_age: 1234, no_endpoints: [{ url: "http://foo.com" }] })
          end.to raise_error(ReportToConfigError)
        end
      end
    end
  end
end
