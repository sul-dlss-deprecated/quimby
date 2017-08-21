class CreateDependencies < ActiveRecord::Migration[5.1]
  def change
    create_table :dependencies do |t|
      t.string :name
      t.string :version
      t.belongs_to :repository, index: true

      t.timestamps
    end
  end
end
