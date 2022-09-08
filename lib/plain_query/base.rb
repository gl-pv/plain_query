class PlainQuery
  attr_reader :relation, :payload

  class << self
    def call(relation, payload = {})
      new(relation, payload).build_query
    end

    def scope(scope_name, &block)
      define_method scope_name do |*args, **aditionalargs|
        mutated_query = instance_exec(*args, **aditionalargs, &block)
        if !mutated_query.is_a?(ActiveRecord::Relation)
          raise(RelationIsIncorrect, 'Scope must be ActiveRecord::Relation')
        end

        @relation = mutated_query
      end
    end
  end

  def initialize(relation, payload)
    @relation = relation
    @payload = payload

    if relation.nil?
      raise(RelationRequired, 'Queries require a base relation defined')
    elsif !relation.is_a?(ActiveRecord::Relation)
      raise(RelationRequired, 'Queries accept only ActiveRecord::Relation as input')
    end
  end

  def call
  end

  def build_query
    call

    relation
  end
end
