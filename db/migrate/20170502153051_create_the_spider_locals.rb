class CreateTheSpiderLocals < ActiveRecord::Migration[5.0]
  def change
    create_table :the_spider_locals do |t|
      t.string :url
      t.text :body
      t.text :draft
      t.timestamps
    end
  end
end
