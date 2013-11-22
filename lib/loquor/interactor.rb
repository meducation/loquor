module Loquor
  module Interactor
    module ClassMethods
      [:find, :find_each, :where, :create].each do |proxy|
        define_method proxy do |*args, &block|
          new.send proxy, *args, &block
        end
      end
    end

    module InstanceMethods
      def find(id)
        ApiCall::Show.new(self.class.path, id).execute
      end

      def find_each(&block)
        ApiCall::Index.new(self.class.path).find_each(&block)
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
