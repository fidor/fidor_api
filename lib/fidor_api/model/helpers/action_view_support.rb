module FidorApi
  module Model
    module Helpers
      module ActionViewSupport
        def self.included(base)
          base.define_singleton_method :model_name do
            ActiveModel::Name.new(self, nil, resource_name)
          end

          base.define_method :persisted? do
            respond_to?(:id) && id.present?
          end
        end

        def model_name
          self.class.model_name
        end
      end
    end
  end
end
