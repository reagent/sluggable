ActiveRecord::Schema.define do

  create_table "blogs", :force => true do |t|
    t.string "name", :null => false
    t.string "slug"
  end

  create_table "posts", :force => true do |t|
    t.string   "title",      :null => false
    t.string   "slug"
    t.text     "body",       :null => false
    t.integer  "blog_id",    :null => false
  end
  
end