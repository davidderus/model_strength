module ModelStrength
  module ActsAsStrength
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def acts_as_strength(*attributes, key: :score, exclude: false, statuses: { 0..30 => :ultra_low, 30..50 => :low, 50..70 => :medium, 70..99 => :high, 100 => :complete })
        # Class and Instance accessors
        cattr_accessor :strength_attributes, :strength_statuses, :strength_exclude, :strength_key, :strength_presents, :strength_missings

        # Active Record Callbacks
        before_create :compute_score
        before_update :compute_score

        # Setting given parameters
        self.strength_attributes = attributes.map { |attr_key| attr_key.to_s }
        self.strength_statuses = statuses
        self.strength_exclude = exclude
        self.strength_key = key

        # Arrays accessors
        self.strength_presents = []
        self.strength_missings = []

        # Including local instance methods
        include ModelStrength::ActsAsStrength::LocalInstanceMethods

        # Adding dynamic method to check key existence
        define_method("#{key}?") { read_attribute(key).present? }

        define_method("#{key}") do
          if self.changed?
            compute_score
          else
            read_attribute(key)
          end
        end
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
          if read_attribute(attribute).present?
            self.class.strength_presents << attribute
            total + strength_step
          else
            self.class.strength_missings << attribute
            total
          end
        end

        write_attribute(self.class.strength_key, value)
      end

      def status
        self.class.strength_statuses.select{ |score, value| score === read_attribute(self.class.strength_key) }.values.last
      end

      protected

      def default_exclude
        %w(id created_at updated_at) << self.class.strength_key.to_s
      end
    end
  end
end

ActiveRecord::Base.send :include, ModelStrength::ActsAsStrength
