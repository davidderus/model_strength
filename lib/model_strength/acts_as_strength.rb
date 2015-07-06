module ModelStrength
  module ActsAsStrength
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def acts_as_strength(*attributes)
        self.attributes = attributes
        nb_attributes = attributes.size
        self.step = (100/nb_attributes)

        include ModelStrength::ActsAsStrength::LocalInstanceMethods
      end
    end

    module LocalInstanceMethods
      def score
        self.class.attributes.inject(0) do |total, attribute|
          total += self.class.step unless read_attribute(attribute).blank?
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, ModelStrength::ActsAsStrength
