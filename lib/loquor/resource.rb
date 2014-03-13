module Loquor
  class Resource

    def initialize(data)
      @data = ObjectHash.new(data, strict: true)
    end

    def method_missing(name, *args)
      @data[name]
    rescue
      raise NameError.new("undefined local variable or method '#{name}' for #{self.class.name}")
    end

    def respond_to?(name)
      return true if super
      @data.respond_to?(name)
    end

    def self.path=(path)
      @path = path
    end

    def self.path
      @path
    end

    def self.cache=(value)
      @value = value
    end

    def self.cache
      @value
    end

    def self.find(id)
      ApiCall::Show.new(self, id).execute
    end

    %w{where per page order select find_each}.each do |meth|
      self.class.send :define_method, meth do |*args, &block|
        ApiCall::Index.new(self).send(meth, *args, &block)
      end
    end

    def self.create(payload)
      ApiCall::Create.new(self, payload: payload).execute
    end

    def self.update(id, payload)
      ApiCall::Update.new(self, id, payload: payload).execute
    end

    def self.destroy(id)
      ApiCall::Destroy.new(self, id).execute
    end
  end
end
