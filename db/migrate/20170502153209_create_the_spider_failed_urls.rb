class CreateTheSpiderFailedUrls < ActiveRecord::Migration[5.1]
  def change
    create_table :the_spider_failed_urls do |t|
      t.string :url
      t.string :source
      t.string :flat
      t.timestamps
    end
  end
end
