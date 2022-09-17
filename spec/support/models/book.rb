# frozen_string_literal: true

class Book < ActiveRecord::Base
  has_many :reviews, class_name: 'BookReview', inverse_of: :book, dependent: :destroy
end
