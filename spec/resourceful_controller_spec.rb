require 'resourceful_controller'
require 'rails'
require 'action_controller'
require 'rspec/rails'

class Application < Rails::Application
end

class TestController < ActionController::Base
  include ResourcefulController
end

describe TestController do
  extend ActionController::TestCase::Behavior
  include RSpec::Rails::ControllerExampleGroup

  describe "resourceful methods" do
    before do
      [:index, :new, :create, :show, :edit, :update, :destroy].each do |method|
        TestController.send(:remove_method, method) if TestController.new.respond_to?(method)
      end
    end

    it "adds all resourceful actions" do
      TestController.act_resourcefully

      [:index, :new, :create, :show, :edit, :update, :destroy].each do |method|
        controller.respond_to?(method).should be_true
      end
    end

    it "removes excepted methods" do
      TestController.act_resourcefully :except => :destroy

      [:index, :new, :create, :show, :edit, :update].each do |method|
        controller.respond_to?(method).should be_true
      end

      controller.respond_to?(:destroy).should be_false
    end

    it "only adds specified actions" do
      TestController.act_resourcefully :only => :destroy

      controller.respond_to?(:destroy).should be_true

      [:index, :new, :create, :show, :edit, :update].each do |method|
        controller.respond_to?(method).should be_false
      end
    end
  end

  describe "support methods" do
    before { TestController.act_resourcefully }

    describe "#resource_name" do
      it "infers the resource name from the controller class" do
        controller.resource_name.should == "test"
      end
    end

    describe "#resource_class" do
      it "infers the resource class from the controller class" do
        controller.resource_class.should == Test
      end
    end

    describe "query methods" do
      let(:query_methods) do
        [:index_query, :find_query, :show_query, :edit_query, :update_query, :destroy_query]
      end

      it "defines default query methods" do
        query_methods.each do |query_method|
          controller.respond_to?(:"default_#{query_method}").should be_true
        end
      end

      it "returns the default query" do
        query = Proc.new { "oncilla" }

        query_methods.each do |query_method|
          controller.stub(:"default_#{query_method}" => query)
          controller.send(:"_#{query_method}").call.should == "oncilla"
        end
      end

      it "defers to a supplied proc" do
        query_methods.each do |query_method|
          TestController.act_resourcefully query_method => lambda { |params| params }
          controller.send(:"_#{query_method}").call("margay").should == "margay"
        end
      end

      it "defers to a supplied method name" do
        class TestController
          def my_query ; "margay" ; end
        end

        query_methods.each do |query_method|
          TestController.act_resourcefully query_method => :my_query
          controller.send(:"_#{query_method}").call.should == "margay"
        end
      end
    end
  end


end