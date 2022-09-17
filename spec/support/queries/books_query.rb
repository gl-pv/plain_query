# frozen_string_literal: true

class BooksQuery
  include PlainQuery::Base(model: Book)

  query_step :search_by_name, if: -> { options[:name].present? }
  query_step :filter_by_genre, if: -> { options[:genre].present? }
  query_step :filter_by_price, if: -> { options[:price].present? }
  query_step :filter_by_discount, if: -> { options[:discount].present? }
  query_step :order_by_name

  def search_by_name
    relation.where("name LIKE ?", "%#{options[:name]}%")
  end

  def filter_by_genre
    relation.where(genre: options[:genre])
  end

  def filter_by_price
    relation.where('price >= ?', options[:price])
  end

  def filter_by_discount
    relation.where('discount >= ?', options[:discount])
  end

  def order_by_name
    relation.order(name: :asc)
  end
end
