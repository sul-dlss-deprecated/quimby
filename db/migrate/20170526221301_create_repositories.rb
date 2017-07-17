class CreateRepositories < ActiveRecord::Migration[5.1]
  def change
    create_table :repositories do |t|
      t.string :name
      t.string :url
      t.string :organization
      t.string :language
      t.string :documentation_url
      t.string :default_branch
      t.string :slug
      t.boolean :current
      t.boolean :has_capistrano
      t.index :has_capistrano
      t.boolean :has_travis
      t.boolean :has_honeybadger
      t.boolean :has_honeybadger_deploy
      t.integer :honeybadger_id
      t.boolean :has_okcomputer
      t.boolean :has_is_it_working
      t.boolean :has_coveralls
      t.boolean :is_private
      t.boolean :is_gem
      t.boolean :is_rails

      t.timestamps
    end
    add_index :repositories, :slug, unique: true
  end
end
