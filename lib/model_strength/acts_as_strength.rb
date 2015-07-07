module ModelStrength
  module ActsAsStrength
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def acts_as_strength(*attributes, exclude: false, statuses: { 0..30 => :ultra_low, 30..50 => :low, 50..70 => :medium, 70..99 => :high, 100 => :complete })
        cattr_accessor :strength_attributes, :strength_statuses, :strength_exclude

        before_create :compute_score
        before_update :compute_score

        self.strength_attributes = attributes.map { |key| key.to_s }
        self.strength_statuses = statuses
        self.strength_exclude = exclude

        include ModelStrength::ActsAsStrength::LocalInstanceMethods
      end
    end

    module LocalInstanceMethods

      def compute_score
        if self.class.strength_exclude
          attributes = self.attributes.except(*(self.class.strength_attributes | default_exclude)).keys
        else
          attributes = self.class.strength_attributes
        end

        nb_attributes = attributes.size
        strength_step = (100/nb_attributes)

        value = attributes.inject(0) do |total, attribute|
          read_attribute(attribute).present? ? (total + strength_step) : total
        end

        write_attribute(:score, value)
      end

      def status
        self.class.strength_statuses.select{ |score, value| score === self.score }.values.last
      end

      protected

      def default_exclude
        ['id', 'created_at', 'updated_at', 'score']
      end
    end
  end
end

ActiveRecord::Base.send :include, ModelStrength::ActsAsStrength
