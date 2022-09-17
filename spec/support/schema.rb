# frozen_string_literal: true

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :books do |t|
    t.string :name
    t.string :genre, default: 0
    t.integer :price, default: 0
    t.integer :discount, default: 0

    t.timestamps
  end

  create_table :book_reviews, force: true do |t|
    t.integer :book_id
    t.string :description
    t.integer :rate, default: 0

    t.timestamps
  end
end
