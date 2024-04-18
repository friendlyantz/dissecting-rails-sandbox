require 'active_record'
require 'awesome_print'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/sample.sqlite3'
)

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    return if ActiveRecord::Base.connection.table_exists?(:users)

    create_table :users do |t|
      t.string :name
    end
  end
end

CreateUsers.new.migrate(:up)

class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    return if ActiveRecord::Base.connection.table_exists?(:posts)

    create_table :posts do |t|
      t.text :content
      t.references :user, foreign_key: true
    end
  end
end

CreatePosts.new.migrate(:up)

class User < ActiveRecord::Base
  validates_presence_of :name, on: :create, message: "can't be blank"
  validates_uniqueness_of :name, on: :create, message: "must be unique"

  has_many :posts
end

class Post < ActiveRecord::Base
  belongs_to :user
end

binding.irb

# user_a = User.new(name: 'Anton')
# user_a.save!
# user_b = User.new(name: 'Anton')
# user_b.valid?
# user_b.errors