require 'active_record'

# Set up the database connection
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

# Create a migration to create the dogs table
class CreateDogs < ActiveRecord::Migration[6.0]
  def change
    create_table :dogs do |t|
      t.string :name
      t.integer :age
    end
  end
end

# Run the migration to create the dogs table
CreateDogs.migrate(:up)

# Define the Dog class, which inherits from ActiveRecord::Base
class Dog < ActiveRecord::Base
  validates :name, presence: true
  validates :age, numericality: { greater_than: 0 }

  def bark
    'Woof!'
  end

  def age_in_dog_years
    age * 7
  end
end

# Testing the Dog class
class DogTest < ActiveSupport::TestCase
  def setup
    @dog = Dog.new(name: 'Fido', age: 3)
  end

  def test_bark
    assert_equal 'Woof!', @dog.bark
  end

  def test_age_in_dog_years
    assert_equal 21, @dog.age_in_dog_years
  end

  def test_name_presence
    @dog.name = nil
    assert_not @dog.valid?
    assert_equal ["can't be blank"], @dog.errors[:name]
  end

  def test_age_numericality
    @dog.age = -2
    assert_not @dog.valid?
    assert_equal ['must be greater than 0'], @dog.errors[:age]
  end
end

# Run the tests
DogTest.new.run
