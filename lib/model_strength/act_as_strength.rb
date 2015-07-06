module ModelStrength
  class ActAsStrength
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def acts_as_strength(*attributes)
        nb_attributes = attributes.size
        step = (100/nb_attributes)
        attributes.inject(0) do |total, attribute|
          total += step unless read_attribute(attribute).blank?
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, ModelStrength::ActAsStrength
