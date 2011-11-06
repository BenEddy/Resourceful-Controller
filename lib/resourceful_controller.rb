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

  delegate :options, :to => :klass

  def klass
    self.class
  end

  module ClassMethods
    include CrudDefinitions

    attr_accessor :options

    def act_resourcefully options = {}
      self.options = options
      define_crud_methods
    end

  end
end
