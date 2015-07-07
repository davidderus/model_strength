module ModelStrength
  module ActsAsStrength
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def acts_as_strength(*attributes, statuses: { 0..30 => :ultra_low, 30..50 => :low, 50..70 => :medium, 70..99 => :high, 100 => :complete })
        cattr_accessor :strength_attributes, :strength_step, :strength_statuses

        before_create :compute_score
        before_update :compute_score

        self.strength_attributes = attributes
        self.strength_statuses = statuses
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

      def status
        self.class.strength_statuses.select{ |score, value| score === self.score }.values.last
      end
    end
  end
end

ActiveRecord::Base.send :include, ModelStrength::ActsAsStrength
