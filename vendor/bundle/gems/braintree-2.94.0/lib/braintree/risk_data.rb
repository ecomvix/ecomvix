module Braintree
  class RiskData # :nodoc:
    include BaseModule

    attr_reader :decision
    attr_reader :device_data_captured
    attr_reader :id
    attr_reader :fraud_service_provider

    def initialize(attributes)
      set_instance_variables_from_hash attributes unless attributes.nil?
    end

    def inspect
      attr_order = [:id, :decision, :device_data_captured, :fraud_service_provider]
      formatted_attrs = attr_order.map do |attr|
        "#{attr}: #{send(attr).inspect}"
      end
      "#<RiskData #{formatted_attrs.join(", ")}>"
    end
  end
end
