class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.text :body
      t.references :user, null: false
      t.references :commentable, polymorphic: true, index: true, null: false      

      t.timestamps
    end
  end
end
