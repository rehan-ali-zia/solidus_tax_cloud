# frozen_string_literal: true

module SolidusTaxCloud
  module Spree
    module OrderDecorator
      def self.prepended(base)
        base.class_eval do
          state_machine.after_transition to: :complete, do: :capture_tax_cloud
        end
      end

      def capture_tax_cloud
        return unless is_taxed_using_tax_cloud?

        response = ::Spree::TaxCloud.transaction_from_order(self).authorized_with_capture
        if response != 'OK'
          Rails.logger.error "ERROR: TaxCloud returned an order capture response of #{response}."
        end
        log_tax_cloud(response)
      end

      # Order.tax_zone.tax_rates is used here to check if the order is taxable by Tax Cloud.
      # It's not possible check against the order's tax adjustments because
      # an adjustment is not created for 0% rates. However, US orders must be
      # submitted to Tax Cloud even when the rate is 0%.
      # Note that we explicitly use ship_address instead of tax_address,
      # as per compliance with Tax Cloud instructions.
      def is_taxed_using_tax_cloud?
        ::Spree::TaxRate.for_address(ship_address).any? { |rate| rate.calculator_type == 'Spree::Calculator::TaxCloudCalculator' }
      end

      def log_tax_cloud(response)
        # Implement into your own application.
        # You could create your own Log::TaxCloud model then use either HStore or
        # JSONB to store the response.
        # The response argument carries the response from an order transaction.
      end

      ::Spree::Order.prepend self
    end
  end
end
