class CreateServers < ActiveRecord::Migration[5.1]
  def change
    create_table :servers do |t|
      t.string :hostname
      t.string :fqdn
      t.inet :ip
      t.string :dev_team
      t.boolean :pupgraded

      t.timestamps
    end
  end
end
