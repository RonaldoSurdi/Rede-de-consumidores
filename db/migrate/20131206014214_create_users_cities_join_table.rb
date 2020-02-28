class CreateUsersCitiesJoinTable < ActiveRecord::Migration
  def self.up
    create_table :cities_users, :id => false do |t|
      t.references :city, index: true
      t.references :user, index: true
    end
  end

  def self.down
    drop_table :cities_users
  end
end