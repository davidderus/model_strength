# ModelStrength

Evaluate completeness by adding a score to your model, as Linkedin do with its Profile Strength.

⚠️ **This gem is out-of-date and contains several security vulnerabilities in its dependencies.** ⚠️

## Usages

### 1. First things first!

```shell
rails generate migration AddScoreToProduct score:integer
```

### 2. Acting as Strength

```ruby
class Product < ActiveRecord::Base
  acts_as_strength :name, :description
end
```

### 3. Getting score and status of an entity

```ruby
p = Product.find(2)
p.score # 50
p.status # :medium
```

### Other possibilities

#### Custom statuses

```ruby
class Product < ActiveRecord::Base
  acts_as_strength :name, :description, statuses: { 0..30 => :humf, 30..50 => :you_can_do_it, 50..70 => :keep_going, 70..99 => :thats_it, 100 => :well_done }
end
```

#### I18n

```ruby
# In en.yml
en:
  front:
    product:
      statuses:
        medium: 'Intermediate'

# In console
p = Product.find(1)
p.status # :medium

puts "front.product.statuses.#{p.status}" # Intermediate
```

#### Exclude mode

```ruby
class Product < ActiveRecord::Base
  acts_as_strength :description, exclude: true
end
```

This mode will take all Product attributes except 'description' in order to compute the score.
Useful with a model with numerous attributes.

**Note that model_strength exclude by default the following keys: 'id', 'created_at', 'updated_at', 'score'**


#### Custom key for score

```ruby
class Product < ActiveRecord::Base
  acts_as_strength :description, key: :strength
end
```

By doing so, score will be stored in a `strength` column. A `strength?` helper will be available.

**Be careful not to forget to add `strength` column to your database!**

#### Model score average

```ruby
# With default key (:score)
Product.strength_average

# With custom key (:strength)
Product.strength_average(:strength)

# With condition(s)
Product.where(brand_id: 1).strength_average
```

## Rake tasks

### For computing score in each entries of a model

```shell
# Bash
rake model_strength:compute_scores[products]

# Zsh
rake 'model_strength:compute_scores[products]'
```

Where `products` is the table name for the `Product` model.


## TODO

- Make some tests
- Handle a block for score or custom `present?` test
- Getting present and blank attributes in a hash
