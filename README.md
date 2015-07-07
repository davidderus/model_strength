# ModelStrength

Evaluate completeness by adding a score to your model, as Linkedin do with its Profile Strength.


### Usage

##### First

``rails generate migration AddScoreToProduct score:integer``

##### Acting as Strength

```
class Product < ActiveRecord::Base
  acts_as_strength :name, :description
end
```

##### Getting score and status of an entity

```
p = Product.find(2)
p.score # 50
p.status # :medium
```

##### Custom statuses

```
class Product < ActiveRecord::Base
  acts_as_strength :name, :description, statuses: { 0..30 => :humf, 30..50 => :you_can_do_it, 50..70 => :keep_going, 70..99 => :thats_it, 100 => :well_done }
end
```
