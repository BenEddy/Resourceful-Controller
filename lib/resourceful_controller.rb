# Options

# :only - Define only the specified actions i.e. :only => :index or :only => [:index, :show]
# :except - Define all actions except the specified actions i.e. :except => :destroy

# :index_query
# :find_query - Used for show, edit, update and destroy
# :show_query
# :edit_query
# :update_query
# :destroy_query


# :create_redirect
# :update_redirect
# :destroy_redirect

require 'active_support'
require 'active_support/core_ext'

require 'resourceful_controller/resource_identification'
require 'resourceful_controller/query_definitions'
require 'resourceful_controller/url_definitions'
require 'resourceful_controller/crud_definitions'

module ResourcefulController
  extend ActiveSupport::Concern
  include ActiveSupport

  include ResourceIdentification
  include QueryDefinitions
  include UrlDefinitions
  include CrudDefinitions

  delegate :options, :to => :klass

  def klass
    self.class
  end

  module ClassMethods
    attr_accessor :options

    def act_resourcefully options = {}
      self.options = options
      define_crud_methods
    end

  end
end
