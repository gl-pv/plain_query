module PlainQuery
  module ClassMethods
    def call(relation = model&.all, options = {})
      new(relation, options).exec_query
    end

    def steps
      @steps ||= []
    end

    def query_step(step_name, params = {})
      steps << [step_name, params]
    end
  end
end
