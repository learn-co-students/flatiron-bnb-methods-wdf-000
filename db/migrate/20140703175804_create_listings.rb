class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string :address,                              null: false
      t.string :listing_type,                         null: false
      t.string :title,                                null: false
      t.text :description,                            null: false
      t.decimal :price, :precision => 8, :scale => 2, null: false
      t.integer :neighborhood_id
      t.integer :host_id
      t.timestamps null: false
    end
  end
end
