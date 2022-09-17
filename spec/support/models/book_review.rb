# frozen_string_literal: true

class BookReview < ActiveRecord::Base
  belongs_to :book, class_name: 'Book', inverse_of: :reviews

  enum rate: %i[bad normal good]
end
