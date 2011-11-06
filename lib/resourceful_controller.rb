require 'active_support'
require 'active_support/core_ext'

module ResourcefulController
  extend ActiveSupport::Concern
  include ActiveSupport

  delegate :resource_name, :resources_name, :resource_class, :options, :to => :klass

  QUERY_METHODS = [:index_query, :find_query, :show_query, :edit_query, :update_query, :destroy_query]

  def klass
    self.class
  end

  def namespace
    controller_path.split("/")[0..-2]
  end

  QUERY_METHODS.each do |query_method|
    define_method :"_#{query_method}" do
      procify(options[query_method]) ||
      send(:"default_#{query_method}")
    end
  end

  def default_index_query
    lambda { |params| resource_class.all }
  end

  def default_find_query
    lambda { |params| resource_class.find(params[:id]) }
  end

  (QUERY_METHODS - [:index_query, :find_query]).each do |query_method|
    alias :"default_#{query_method}" :default_find_query
  end

  def procify option
    return unless option
    option.is_a?(Proc) ? option : Proc.new { send option }
  end

  def index_path
    namespace.push(resources_name)
  end

  def show_path
    namespace.push(instance_variable_get(:"@#{resource_name}"))
  end

  module ClassMethods
    attr_accessor :options

    def act_resourcefully options = {}
      self.options = options
      define_methods
    end

    def define_methods
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

    def resource_name
      resources_name.singularize
    end

    def resources_name
      controller_name
    end

    def resource_class
      resource_name.classify.constantize
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
