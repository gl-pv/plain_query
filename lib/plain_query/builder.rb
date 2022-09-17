# frozen_string_literal: true

require 'plain_query/builder_options'
require 'plain_query/class_methods'
require 'plain_query/instance_methods'
require 'plain_query/version'

module PlainQuery
  class Builder < Module
    attr_reader :builder_options

    def initialize(model: nil)
      @builder_options = BuilderOptions.new(model: model)
    end

    def included(klass)
      klass.extend(builder_options)
      klass.extend(ClassMethods)
      klass.include(InstanceMethods)
    end
  end
end
