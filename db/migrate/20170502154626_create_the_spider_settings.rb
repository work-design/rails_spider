class CreateTheSpiderSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :the_spider_works do |t|
      t.string :name
      t.string :parser_name, limit: 50
      t.string :host
      t.string :list_path
      t.string :item_path
      t.string :page_params
      t.timestamps
    end
  end
end
