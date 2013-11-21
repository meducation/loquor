module Loquor
  module Representation
    module ClassMethods
      [:find, :where, :create].each do |proxy|
        define_method proxy do |*args|
          new.send proxy, *args
        end
      end
    end

    module InstanceMethods
      def find(id)
        ApiCall::Show.new(self.class.path, id).execute
      end

      def where(*args)
        ApiCall::Index.new(self.class.path).where(*args)
      end

      def create(payload)
        ApiCall::Create.new(self.class.path, payload).execute
      end
    end
  end
end
