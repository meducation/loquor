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

    def self.find_each(&block)
      ApiCall::Index.new(self).find_each(&block)
    end

    def self.select(*args)
      ApiCall::Index.new(self).select(*args)
    end

    def self.where(*args)
      ApiCall::Index.new(self).where(*args)
    end

    def self.create(payload)
      ApiCall::Create.new(self, payload).execute
    end

    def self.update(id, payload)
      ApiCall::Update.new(self, id, payload: payload).execute
    end
  end
end
