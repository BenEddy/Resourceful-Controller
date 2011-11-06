module ResourcefulController
  module ResourceIdentification
    extend ActiveSupport::Concern

    delegate :resource_name, :resources_name, :resource_class, :to => :klass

    module ClassMethods

      def resource_name
        resources_name.singularize
      end

      def resources_name
        controller_name
      end

      def resource_class
        resource_name.classify.constantize
      end

    end
  end
end