class CreateTheSpiderBodies < ActiveRecord::Migration[5.1]
  def change
    create_table :the_spider_bodies do |t|

      t.timestamps
    end
  end
end
