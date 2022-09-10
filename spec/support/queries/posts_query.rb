# frozen_string_literal: true

class PostsQuery < PlainQuery
  model Post

  query_step :search_by_title, if: -> { options[:title].present? }
  query_step :get_moderated, unless: :with_unmoderated?
  query_step :order_by_count_of_views

  def search_by_title
    relation.where(title: options[:title])
  end

  def get_moderated
    relation.where(moderated: true)
  end

  def order_by_count_of_views
    relation.order(count_of_views: :desc)
  end

  def with_unmoderated?
    options[:with_unmoderated]
  end
end
