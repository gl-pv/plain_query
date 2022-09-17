# frozen_string_literal: true

class BestBooksQuery < BooksQuery
  query_step :filter_by_good_rate
  query_step :order_by_name

  def filter_by_good_rate
    relation.joins(:reviews).where(book_reviews: { rate: BookReview.rates[:good] }).distinct
  end

  def order_by_name
    relation.order(name: :asc)
  end
end
