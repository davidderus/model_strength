module ModelStrength
  module ActsAsStrength
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def acts_as_strength(*attributes)
        cattr_accessor :attributes, :step
        before_create :compute_score
        before_update :compute_score

        self.attributes = attributes
        nb_attributes = attributes.size
        self.step = (100/nb_attributes)

        include ModelStrength::ActsAsStrength::LocalInstanceMethods
      end
    end

    module LocalInstanceMethods
      def compute_score
        value = self.class.attributes.inject(0) do |total, attribute|
          read_attribute(attribute).blank? ? total : (total + self.class.step)
        end

        write_attribute(:score, value)
      end
    end
  end
end

ActiveRecord::Base.send :include, ModelStrength::ActsAsStrength
