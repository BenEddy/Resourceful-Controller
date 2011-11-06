module ResourcefulController
  module CrudDefinitions
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
        instance_variable_set(:"@#{resources_name}", _index_query.call(params))
      end
    end

    def define_new
      define_method :new do
        instance_variable_set(:"@#{resource_name}", resource_class.new)
      end
    end

    def define_create
      define_method :create do
        instance_variable_set(:"@#{resource_name}", resource_class.new(params[:"#{resource_name}"]))
        if instance_variable_get(:"@#{resource_name}").save
          send(:redirect_to, show_path, :notice => "#{resource_name.titleize.capitalize} successfully created")
        else
          render :new
        end
      end
    end

    def define_show
      define_method :show do
        instance_variable_set(:"@#{resource_name}", _find_query.call(params))
      end
    end

    def define_edit
      define_method :edit do
        instance_variable_set(:"@#{resource_name}", _find_query.call(params))
      end
    end

    def define_update
      define_method :update do
        instance_variable_set(:"@#{resource_name}", _find_query.call(params))
        if instance_variable_get(:"@#{resource_name}").update_attributes(params[:"#{resource_name}"])
          redirect_to show_path, :notice => "#{resource_name.titleize.capitalize} successfully updated"
        else
          render :edit
        end
      end
    end

    def define_destroy
      define_method :destroy do
        resource = _find_query.call(params)
        resource.destroy
        redirect_to index_path, :notice => "#{resource_name.titleize.capitalize} successfully deleted"
      end
    end
  end
end