# frozen_string_literal: true

module SecureHeaders
  class ReportToConfigError < StandardError; end
  class ReportTo
    HEADER_NAME = "Report-To"

    class << self
      def make_header(config = nil)
        return if config.nil? || config == OPT_OUT
        [HEADER_NAME, config_json(config)]
      end

      def config_json(config)
        hyphenated_hash = {}
        config.each do |k, v|
          new_key = k.to_s.tr("_", "-")
          hyphenated_hash[new_key] = v
        end
        @config_json ||= hyphenated_hash.to_json
      end

      def validate_config!(config)
        return if config.nil? || config == OPT_OUT

        raise ReportToConfigError.new("Value must be given as a array") unless config.is_a?(Array)

        config.each do |h|
          raise ReportToConfigError.new("Each value in the array must be a hash") unless config.is_a?(Hash)

          keys = config.keys
          raise ReportToConfigError.new("Missing group value") unless keys.include?(:group)
          raise ReportToConfigError.new("Missing max_age value") unless keys.include?(:max_age)
          raise ReportToConfigError.new("Missing endpoints value") unless keys.include?(:endpoints)
        end
      end
    end
  end
end
