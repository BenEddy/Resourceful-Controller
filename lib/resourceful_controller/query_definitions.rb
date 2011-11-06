module ResourcefulController
  module QueryDefinitions
    QUERY_METHODS = [:index_query, :find_query, :show_query, :edit_query, :update_query, :destroy_query]

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

  end
end