module JeraPush
  module Services
    class BaseService
      extend ActiveModel::Naming

      def initialize(*)
        @errors = ActiveModel::Errors.new(self)
      end

      def read_attribute_for_validation(attr)
        send(attr)
      end
    
      def self.human_attribute_name(attr, options = {})
        attr
      end
    
      def self.lookup_ancestors
        [self]
      end
    end
  end
end
