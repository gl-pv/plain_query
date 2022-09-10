# frozen_string_literal: true

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :posts, force: true do |t|
    t.string :title
    t.string :content
    t.boolean :moderated, default: false
    t.integer :count_of_views, default: 0
    t.float :reading_duration, default: 0.0

    t.timestamps
  end
end
