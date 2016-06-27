module FidorApi
  module Transfer
    module Generic
      def self.included(base)
        base.extend ModelAttribute
        base.extend AmountAttributes

        base.validates *required_attributes, presence: true

        base.attribute :id,             :string
        base.attribute :account_id,     :string
        base.attribute :external_uid,   :string
        base.attribute :contact_name,   :string
        base.attribute :subject,        :string
        base.attribute :currency,       :string
        base.attribute :subject,        :string
        base.attribute :state,          :string
        base.attribute :created_at,     :time
        base.attribute :updated_at,     :time
        base.amount_attribute :amount

        base.singleton_class.instance_eval do
          define_method :resource do
            "transfers"
          end
        end
      end

      def self.required_attributes
        [ :account_id, :external_uid, :contact_name, :account_number, :routing_code, :amount, :subject, :currency ]
      end

      def as_json
        {
          account_id: account_id,
          external_uid: external_uid,
          amount: (amount * 100).to_i,
          currency: currency,
          subject: subject,
          beneficiary: {
            contact: {
              name: contact_name
            },
            routing_type: as_json_routing_type,
            routing_info: as_json_routing_info
          }
        }
      end

      private

      def contact
        (beneficiary || {}).fetch("contact", {})
      end

      def routing_info
        (beneficiary || {}).fetch("routing_info", {})
      end

      def map_errors(fields)
        fields.each do |hash|
          if respond_to? hash["field"].to_sym
            errors.add(hash["field"].to_sym, hash["message"])
          elsif hash["field"] == "beneficiary" && invalid_fields = hash["message"][/Invalid fields in routing_info: (.*)/, 1]
            invalid_fields.split(",").each do |invalid_field|
              errors.add(invalid_field, :invalid)
            end
          end
        end
      end
    end
  end
end
