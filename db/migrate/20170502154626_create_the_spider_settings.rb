class CreateTheSpiderSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :the_spider_works do |t|
      t.string :name
      t.string :list
      t.string :item
      t.string :page_params
      t.timestamps
    end
  end
end
