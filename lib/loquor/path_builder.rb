module Loquor

  class MissingUrlComponentError < LoquorError
    def initialize(url_component)
      @url_component = url_component
    end

    def message
      "#{url_component} has not been set. Use Object.for_#{url_component}"
    end
  end

  module PathBuilder
    PATH_PART_REGEX = /:[a-z0-9_]+/

    def setup_path_builder(path)
      path.split('/').each do |path_part|
        next unless path_part =~ PATH_PART_REGEX
        path_part = path_part[1..-1]
        method_name = "for_#{path_part}"

        self.class.send :define_method, method_name do |id|
          @path_parts ||= {}
          @path_parts[path_part.to_sym] = id
          self
        end

        self.class.class_eval <<-EOS
          def self.#{method_name}(*args)
            new.#{method_name}(*args)
          end
        EOS
      end

      self.class.send :define_method, :build_path do
        path.gsub(PATH_PART_REGEX) do |path_part|
          path_part = path_part[1..-1].to_sym
          @path_parts ||= {}
          @path_parts.fetch(path_part) { raise MissingUrlComponentError.new(path_part) }
        end
      end
    end
  end
end
