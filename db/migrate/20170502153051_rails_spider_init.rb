class RailsSpiderInit < ActiveRecord::Migration[5.0]
  def change

    create_table :spider_works do |t|
      t.string :name
      t.string :parser_name, limit: 50
      t.string :host
      t.string :list_path
      t.string :item_path
      t.string :page_params
      t.timestamps
    end

    create_table :spider_resources do |t|
      t.references :spider_work
      t.string :code
      t.string :xpath
      t.string :css
      t.boolean :squish, default: false
      t.timestamps
    end

    create_table :spider_caches do |t|
      t.references :spider_work
      t.string :url
      t.text :body
      t.text :draft
      t.timestamps
    end

    create_table :spider_sessions do |t|
      t.string :name
      t.string :domain
      t.string :password
      t.string :value
      t.string :cookie
      t.timestamps
    end

    create_table :spider_fails do |t|
      t.string :url
      t.string :source
      t.string :flat
      t.timestamps
    end

  end
end
