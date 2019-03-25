require 'hashdiff'

module RbVmomi
  # Utility class for VMware Managed Object Designed Language
  #
  # @author J.R. Garcia <jrg@vmware.com>
  # @since 2.0.1
  class VMODL
    # Create a VMODL object from a marshaled file
    #
    # @author J.R. Garcia <jrg@vmware.com>
    #
    # @since 2.0.1
    #
    # @param [String] file the path to create the VMODL object from
    #
    # @return [VMODL] the created VMODL
    def self.from_file(file = '')
      raise ArgumentError, "'#{file}' doesn't exist" unless File.exist?(file)
      new.tap { |o| o.instance_variable_set(:@file, file) }
    end

    # Translate a VMODL object to a Hash
    #
    # @author J.R. Garcia <jrg@vmware.com>
    #
    # @since 2.0.1
    #
    # @return [Hash] a Hash representation of the VMODL
    def to_h
      Marshal.load(IO.read(@file))
    end

    # Diff this VMODL with another VMODL
    #
    # @author J.R. Garcia <jrg@vmware.com>
    #
    # @since 2.0.1
    #
    # @return a diff of the VMODLs
    def diff(other)
      HashDiff.diff(self.to_h, other.to_h)
    end

    private

    attr_accessor :file
  end
end
