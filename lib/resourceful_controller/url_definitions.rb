module ResourcefulController
  module UrlDefinitions
    def namespace
      controller_path.split("/")[0..-2]
    end

    def create_redirect
      options[:create_redirect] || default_create_redirect
    end

    def default_create_redirect
      redirect_to show_url, :notice => "#{resource_name.titleize.capitalize} successfully created"
    end

    def update_redirect
      options[:update_redirect] || default_update_redirect
    end

    def default_update_redirect
      redirect_to show_url, :notice => "#{resource_name.titleize.capitalize} successfully updated"
    end

    def destroy_redirect
      options[:destroy_redirect] || default_destroy_redirect
    end

    def default_destroy_redirect
      redirect_to index_url, :notice => "#{resource_name.titleize.capitalize} successfully deleted"
    end

    def index_url
      url_for namespace.push(resources_name)
    end

    def show_url
      url_for namespace.push(instance_variable_get(:"@#{resource_name}"))
    end
  end
end