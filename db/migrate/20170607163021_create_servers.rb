class CreateServers < ActiveRecord::Migration[5.1]
  def change
    create_table :servers do |t|
      t.string :hostname
      t.string :fqdn
      t.string :ip
      t.string :dev_team
      t.boolean :pupgraded
      t.string :network

      t.timestamps
    end
  end
end
