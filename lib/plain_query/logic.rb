# Realises methods for scope building by execution of sequence of steps
# Query class defines query steps:
# query_step :filter_by_status, if: -> { options[:status].present? }
# def filter_by_status
#   relation.where(status: options[:status])
# end
class PlainQuery
  attr_reader :relation, :options

  def initialize(relation, options)
    @relation = relation
    @options = options
    @steps = self.class.steps

    # Validates initial relation format. Allowed only ActiveRecord::Relation, model class.
    if relation.nil?
      raise(RelationRequired, 'Queries require a base relation defined')
    elsif !relation.is_a?(ActiveRecord::Relation)
      raise(RelationRequired, 'Queries accept only ActiveRecord::Relation as input')
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
      if !mutated_query.is_a?(ActiveRecord::Relation)
        raise(RelationIsIncorrect, 'Scope must be ActiveRecord::Relation')
      end

      @relation = mutated_query
    end

    @relation
  end

  # Executes if and unless conditions, conditions must contain object method name or proc (lambda)
  def exec_condition(condition)
    if condition.is_a?(String) || condition.is_a?(Symbol)
      !!send(condition)
    elsif condition.is_a?(Proc)
      !!instance_exec(&condition)
    else
      raise(ConditionFormatIsIncorrect, 'Condition must be method name or proc')
    end
  end

  class << self
    def call(relation = @model&.all, options = {})
      new(relation, options).exec_query
    end

    def query_step(step_name, params = {})
      steps << [step_name, params]
    end

    def steps
      @steps ||= []
    end

    def model(model)
      @model = model
    end
  end
end
