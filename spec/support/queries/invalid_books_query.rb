# frozen_string_literal: true

class InvalidBooksQuery
  include PlainQuery::Base

  query_step :filter_query

  def filter_query
    relation.count
  end
end
