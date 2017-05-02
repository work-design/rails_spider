class CreateTheSpiderCookies < ActiveRecord::Migration[5.1]
  def change
    create_table :the_spider_cookies do |t|
      t.string :name
      t.string :domain
      t.string :password
      t.string :value
      t.timestamps
    end
  end
end
