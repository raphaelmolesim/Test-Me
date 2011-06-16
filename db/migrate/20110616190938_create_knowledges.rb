class CreateKnowledges < ActiveRecord::Migration
  def self.up
    create_table :knowledges do |t|
      t.string :name
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :knowledges
  end
end
