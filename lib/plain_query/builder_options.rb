# frozen_string_literal: true

module PlainQuery
  class BuilderOptions < Module
    def initialize(model: nil)
      define_model(model)
    end

    def define_model(model)
      module_exec(model) do |model_name|
        define_method(:model) do
          model_name
        end
      end
    end
  end
end
