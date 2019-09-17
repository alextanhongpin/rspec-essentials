class Object
  def self.mock(method_name, return_value)
    klass = self

    # Store existing method, if there is one, for restoration.
    existing_method = if klass.method_defined?(method_name)
      klass.instance_method(method_name)
    else
      nil
    end

    klass.send(:define_method, method_name) do |*args|
      return_value
    end

    # Execute the passed block with the mock in effect.
    yield if block_given?
  ensure
    # Restore klass to previous condition.
    if existing_method
      klass.send(:define_method, method_name, existing_method)
    else
      klass.send(:remove_method, method_name)
    end
  end
end
