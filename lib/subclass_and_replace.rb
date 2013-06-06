module SubclassAndReplace

  class << self

    def replaced_classes
      @replaced_classes ||= {}
    end

    def subclass_and_replace(klass, &block)
      klass_path = klass.name

      raise "'#{klass_path}' has already been replaced" unless SubclassAndReplace.replaced_classes[klass_path].nil?


      namespace, klass_name = get_namespace_and_klass_name(klass_path)

      new_klass = Class.new(klass, &block)

      SubclassAndReplace.replaced_classes[klass_path] = replace_constant(namespace, klass_name, new_klass)

      new_klass
    end

    def revert(klass)
      klass_path = klass.name

      return false if SubclassAndReplace.replaced_classes[klass_path].nil?

      namespace, klass_name = get_namespace_and_klass_name(klass_path)

      replace_constant(namespace, klass_name, SubclassAndReplace.replaced_classes.delete(klass_path))

      true
    end

    protected

    def get_namespace_and_klass_name(klass_path)
      path_array = klass_path.split('::')
      klass_name = path_array.pop

      namespace = path_array.size > 0 ? Kernel.const_get( path_array.join('::') ) : Object

      [namespace, klass_name]
    end

    def replace_constant(namespace, klass_name, new_klass)
      old_klass = namespace.send(:remove_const, klass_name)
      namespace.const_set(klass_name, new_klass)
      old_klass
    end

  end

  module Methods

    protected

    def subclass_and_replace(klass, &block)
      SubclassAndReplace.subclass_and_replace(klass, &block)
    end

  end

end

include SubclassAndReplace::Methods