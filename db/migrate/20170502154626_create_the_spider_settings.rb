class CreateTheSpiderSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :the_spider_settings do |t|

      t.timestamps
    end
  end
end
