module ResourcefulController
  module UrlDefinitions
    def namespace
      controller_path.split("/")[0..-2]
    end

    def index_path
      namespace.push(resources_name)
    end

    def show_path
      namespace.push(instance_variable_get(:"@#{resource_name}"))
    end
  end
end