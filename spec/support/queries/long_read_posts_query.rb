# frozen_string_literal: true

class LongReadPostsQuery < PostsQuery
  query_step :filter_by_reading_duration
  query_step :order_by_count_of_views

  def filter_by_reading_duration
    relation.where('reading_duration > ?', options[:reading_duration_gt])
  end
end
