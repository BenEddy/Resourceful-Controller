module ResourcefulController
  module CrudDefinitions
    extend ActiveSupport::Concern

    def get_resource
      instance_variable_get(:"@#{resource_name}")
    end

    def get_resources
      instance_variable_get(:"@#{resources_name}")
    end

    def set_resource value
      instance_variable_set(:"@#{resource_name}", value)
    end

    def set_resources value
      instance_variable_set(:"@#{resources_name}", value)
    end

    module ClassMethods
      def define_crud_methods
        methods.each { |method| send(:"define_#{method}") }
      end

      def methods
        methods = default_methods - excepted_methods
        methods = methods & specified_methods if specified_methods.present?
        return methods
      end

      def excepted_methods
        Array.wrap(@options[:except])
      end

      def specified_methods
        Array.wrap(@options[:only])
      end

      def default_methods
        [:index, :new, :create, :show, :edit, :update, :destroy]
      end

      def define_index
        define_method :index do
          set_resources(_index_query.call(params))

          respond_to do |format|
            format.html
            format.json { render :json => get_resources }
          end
        end
      end

      def define_new
        define_method :new do
          set_resource resource_class.new

          respond_to do |format|
            format.html
            format.json { render :json => get_resource }
          end
        end
      end

      def define_create
        define_method :create do
          set_resource resource_class.new(params[:"#{resource_name}"])

          respond_to do |format|
            if get_resource.save
              format.html { create_redirect }
              format.json { render :json => get_resource, :status => :created, :location => get_resource }
            else
              format.html { render :action => :new }
              format.json { render :json => get_resource.errors, :status => :unprocessable_entity }
            end
          end
        end
      end

      def define_show
        define_method :show do
          set_resource _show_query.call(params)

          respond_to do |format|
            format.html
            format.json { render :json => get_resource }
          end
        end
      end

      def define_edit
        define_method :edit do
          set_resource _edit_query.call(params)
        end
      end

      def define_update
        define_method :update do
          set_resource _update_query.call(params)

          respond_to do |format|
            if get_resource.update_attributes(params[:"#{resource_name}"])
              format.html { update_redirect }
              format.json { head :ok }
            else
              format.html { render :action => "edit" }
              format.json { render :json => get_resource.errors, :status => :unprocessable_entity }
            end
          end
        end
      end

      def define_destroy
        define_method :destroy do
          resource = _destroy_query.call(params)
          resource.destroy

          respond_to do |format|
            format.html { destroy_redirect }
            format.json { head :ok }
          end
        end
      end
    end
  end
end