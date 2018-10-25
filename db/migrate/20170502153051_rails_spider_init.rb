class RailsSpiderInit < ActiveRecord::Migration[5.0]
  def change

    create_table :rails_spider_locals do |t|
      t.references :work
      t.string :url
      t.text :body
      t.text :draft
      t.timestamps
    end

    create_table :rails_spider_cookies do |t|
      t.string :name
      t.string :domain
      t.string :password
      t.string :value
      t.timestamps
    end

    create_table :rails_spider_failed_urls do |t|
      t.string :url
      t.string :source
      t.string :flat
      t.timestamps
    end

    create_table :rails_spider_works do |t|
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
