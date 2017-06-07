class CreateDeployEnvironments < ActiveRecord::Migration[5.1]
  def change
    create_table :deploy_environments do |t|
      t.string :name
      t.belongs_to :server, index: true
      t.belongs_to :repository, index: true

      t.timestamps
    end
  end
end
