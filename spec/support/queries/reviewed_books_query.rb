# frozen_string_literal: true

class ReviewedBooksQuery
  include PlainQuery::Base(model: Book)

  query_step :filter_by_rate_presence

  def filter_by_rate_presence
    relation.joins(:reviews).distinct
  end
end
