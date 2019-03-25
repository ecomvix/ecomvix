# frozen_string_literal: true

module ActiveRecord
  module AttributeMethods
    module Read
      extend ActiveSupport::Concern

      module ClassMethods # :nodoc:
        private

          def define_method_attribute(name)
            sync_with_transaction_state = "sync_with_transaction_state" if name == primary_key

            ActiveModel::AttributeMethods::AttrNames.define_attribute_accessor_method(
              generated_attribute_methods, name
            ) do |temp_method_name, attr_name_expr|
              generated_attribute_methods.module_eval <<-RUBY, __FILE__, __LINE__ + 1
                def #{temp_method_name}
                  #{sync_with_transaction_state}
                  name = #{attr_name_expr}
                  _read_attribute(name) { |n| missing_attribute(n, caller) }
                end
              RUBY
            end
          end
      end

      # Returns the value of the attribute identified by <tt>attr_name</tt> after
      # it has been typecast (for example, "2004-12-12" in a date column is cast
      # to a date object, like Date.new(2004, 12, 12)).
      def read_attribute(attr_name, &block)
        name = attr_name.to_s
        if self.class.attribute_alias?(name)
          name = self.class.attribute_alias(name)
        end

        primary_key = self.class.primary_key
        name = primary_key if name == "id" && primary_key
        sync_with_transaction_state if name == primary_key
        _read_attribute(name, &block)
      end

      # This method exists to avoid the expensive primary_key check internally, without
      # breaking compatibility with the read_attribute API
      def _read_attribute(attr_name, &block) # :nodoc
        @attributes.fetch_value(attr_name.to_s, &block)
      end

      alias :attribute :_read_attribute
      private :attribute
    end
  end
end
