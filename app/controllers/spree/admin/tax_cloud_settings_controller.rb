# frozen_string_literal: true

module Spree
  module Admin
    class TaxCloudSettingsController < Spree::Admin::BaseController
      def edit
        @preferences_tic = [:taxcloud_default_product_tic, :taxcloud_shipping_tic]
      end

      def update
        params.each do |name, value|
          Spree::Config[name] = value if Spree::Config.has_preference? name
        end

        flash[:success] = I18n.t('spree.successfully_updated', resource: I18n.t('spree.tax_cloud_settings'))
        redirect_to edit_admin_tax_cloud_settings_path
      end

      def dismiss_alert
        if request.xhr? && params[:alert_id]
          dismissed = Spree::Config[:dismissed_spree_alerts] || ''
          Spree::Config.set dismissed_spree_alerts: dismissed.split(',').push(params[:alert_id]).join(',')
          filter_dismissed_alerts
          render nothing: true
        end
      end
    end
  end
end
