module ModelStrength
  module ActsAsStrength
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def acts_as_strength(*attributes, weights: { 0 => :empty, 30 => :low, 50 => :medium, 70 => :high, 100 => :complete })
        cattr_accessor :strength_attributes, :strength_step, :strength_weights

        before_create :compute_score
        before_update :compute_score

        self.strength_attributes = attributes
        self.strength_weights = weights
        nb_attributes = attributes.size
        self.strength_step = (100/nb_attributes)

        include ModelStrength::ActsAsStrength::LocalInstanceMethods
      end
    end

    module LocalInstanceMethods

      def compute_score
        value = self.class.strength_attributes.inject(0) do |total, attribute|
          read_attribute(attribute).present? ? (total + self.class.strength_step) : total
        end

        write_attribute(:score, value)
      end

      def weight
        self.class.strength_weights.select{ |score, value| score <= self.score }.values.last
      end
    end
  end
end

ActiveRecord::Base.send :include, ModelStrength::ActsAsStrength
