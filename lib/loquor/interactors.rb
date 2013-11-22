Loquor::Interactors.each do |name, path|
  klass = Class.new(Object) do
    extend Loquor::Interactor::ClassMethods
    include Loquor::Interactor::InstanceMethods

    instance_eval <<-EOS
      def path
        "#{path}"
      end
    EOS
  end

  # Split off the Group and Discussion parts
  name_parts = name.split("::")
  klass_name = name_parts.pop

  # Create base modules
  const = Loquor
  name_parts.each do |name_part|
    const.const_set name_part, Module unless const.const_defined?(name_part)
  end

  # Define the actual klass at the right point
  const.const_set klass_name, klass
end
