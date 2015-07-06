module ModelStrength
  class ActAsStrength
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def acts_as_strengthable(*attributes)
        # TODO
      end
    end
  end
end

ActiveRecord::Base.send :include, ModelStrength::ActAsStrength
