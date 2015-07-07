# ModelStrength

Evaluate completeness by adding a score to your model, as Linkedin do with its Profile Strength.


### Usage

1. First

```
rails generate migration AddScoreToProduct score:integer
```

2. Acting as Strength

```
class Product < ActiveRecord::Base
  acts_as_strength :name, :description
end
```

3. Getting score and status of an entity

```
p = Product.find(2)
p.score # 50
p.status # :medium
```

### Other possibilities

- Custom statuses

```
class Product < ActiveRecord::Base
  acts_as_strength :name, :description, statuses: { 0..30 => :humf, 30..50 => :you_can_do_it, 50..70 => :keep_going, 70..99 => :thats_it, 100 => :well_done }
end
```

- Exclude mode

```
class Product < ActiveRecord::Base
  acts_as_strength :description, exclude: true
end
```

This mode will take all Product attributes except 'description' in order to compute the score.
Useful with a model with numerous attributes.

**Note that model_strength exclude by default the following keys: 'id', 'created_at', 'updated_at', 'score'**