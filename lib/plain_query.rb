# frozen_string_literal: true

require 'plain_query/builder'

module PlainQuery
  # Realises methods for scope building by execution of sequence of steps
  # Query class defines query steps:
  # query_step :filter_by_status, if: -> { options[:status].present? }
  #
  # def filter_by_status
  #   relation.where(status: options[:status])
  # end
  module Base
    def self.included(klass)
      klass.include(PlainQuery::Base())
    end
  end
  # This method allows to declare model parameter associated with this query object.
  # Model parameter is useful for model scopes building
  # Example:
  # class UsersQuery
  #   include PlainQuery::Base(model: User)
  #   ...
  # end
  # class User < ActiveRecord::Base
  #   scope :available, UsersQuery
  # end
  def self.Base(model: nil)
    PlainQuery::Builder.new(model: model)
  end
end

