module ModelStrength
  module ActsAsStrength
    extend ActiveSupport::Concern

    included do
    end

    STRENGTH_DEFAULT_KEY = :score.freeze

    module ClassMethods
      def acts_as_strength(*attributes, key: STRENGTH_DEFAULT_KEY, exclude: false, statuses: { 0..30 => :ultra_low, 30..50 => :low, 50..70 => :medium, 70..99 => :high, 100 => :complete })
        # Class and Instance accessors
        cattr_accessor :strength_attributes, :strength_statuses, :strength_exclude, :strength_key, :strength_presents, :strength_missings

        # Active Record Callbacks
        before_create :store_score
        before_update :store_score

        # Setting given parameters
        self.strength_attributes = attributes.map { |attr_key| attr_key.to_s }
        self.strength_statuses = statuses
        self.strength_exclude = exclude
        self.strength_key = key

        # Arrays accessors
        self.strength_presents = []
        self.strength_missings = []

        # Adding dynamic method to check key existence
        define_method("#{key}?") { read_attribute(key).present? }

        # Adding override for getter method
        define_method("#{key}") do
          if self.changed?
            current_score
          else
            read_attribute(key)
          end
        end

        # Including local instance methods
        include ModelStrength::ActsAsStrength::LocalInstanceMethods
      end

      # Average helper
      def strength_average(key = STRENGTH_DEFAULT_KEY)
        self.average(key).to_i
      end
    end

    module LocalInstanceMethods
      def status
        self.class.strength_statuses.select{ |score, value| score === read_attribute(self.class.strength_key) }.values.last
      end

      protected

      def current_score
        filtered_attributes.inject(0) do |total, attribute|
          if read_attribute(attribute).present?
            self.class.strength_presents << attribute
            total + strength_step
          else
            self.class.strength_missings << attribute
            total
          end
        end
      end

      def filtered_attributes
        @filtered_attributes ||= if self.class.strength_exclude
                                   self.attributes.except(*(self.class.strength_attributes | excluded_keys)).keys
                                 else
                                   self.class.strength_attributes
                                 end
      end

      def strength_step
        @strength_step ||= (100 / filtered_attributes.size)
      end

      def store_score
        write_attribute(self.class.strength_key, current_score)
      end

      def excluded_keys
        %w(id created_at updated_at) << self.class.strength_key.to_s
      end
    end
  end
end

ActiveRecord::Base.send :include, ModelStrength::ActsAsStrength
