# frozen_string_literal: true

module PlainQuery
  module InstanceMethods
    attr_reader :relation, :options

    def initialize(relation, options)
      @relation = relation
      @options = options
      @steps = self.class.steps

      # Validates initial relation format. Allowed only ActiveRecord::Relation.
      unless @relation.is_a?(ActiveRecord::Relation)
        raise(StandardError, 'Queries accept only ActiveRecord::Relation as input')
      end
    end

    def exec_query
      @steps.each do |step_name, params|
        # Handles if condition
        if (params[:if] && !exec_condition(params[:if]))
          next
        end

        # Handles unless condition
        if (params[:unless] && exec_condition(params[:unless]))
          next
        end

        # Executes query mutation and checks that step returns ActiveRecord::Relation
        mutated_query = send(step_name)
        unless mutated_query.is_a?(ActiveRecord::Relation)
          raise(StandardError, 'Scope must be ActiveRecord::Relation')
        end

        @relation = mutated_query
      end

      @relation
    end

    # Executes if and unless conditions, conditions must contain object method name or proc (lambda)
    def exec_condition(condition)
      if [String, Symbol].member?(condition.class)
        !!send(condition)
      elsif condition.is_a?(Proc)
        !!instance_exec(&condition)
      else
        raise(StandardError, 'Condition must be method name or proc')
      end
    end
  end
end
