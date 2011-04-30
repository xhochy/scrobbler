module Scrobbler
  # Defines some functions that are used nearly all Scrobbler classes which
  # have to deal with image references.
  #
  # This module defines the class functions, use "extend ImageClassFuncs" in
  # class.
  module ImageClassFuncs
    # Check if the given libxml node is an image referencing node and in case
    # of, read it into that given hash of data 
    #
    # @param [Hash<Symbol, String>] data The data extracted from an API response
    # @param [(LibXML::)XML::Node] node XML node, part of the API response
    def maybe_image_node(data, node)
      raise ArgumentError unless data.kind_of?(Hash)
      if node.name == 'image'
        case node['size'].to_s # convert to string to fix libxml-ruby bug
          when 'small'
            data[:image_small] = node.content
          when 'medium'
            data[:image_medium] = node.content
          when 'large'
            data[:image_large] = node.content
          when 'extralarge'
            data[:image_extralarge] = node.content
          else
            raise NotImplementedError, "Image size '#{node['size'].to_s}' not supported."
        end #^ case
      end #^ if
    end #^ maybe_ ...

  end
  
  # Defines some functions that are used nearly all Scrobbler classes which
  # have to deal with image references.
  #
  # This module defines the object functions, use "include ImageObjectFuncs" in
  # class.
  module ImageObjectFuncs
    # Check if the given libxml node is an image referencing node and in case
    # of, read it into the object
    def check_image_node(node)
      if node.name == 'image'
        case node['size'].to_s # convert to string to fix libxml-ruby bug
          when 'small'
            @image_small = node.content
          when 'medium'
            @image_medium = node.content
          when 'large'
            @image_large = node.content
          when 'extralarge'
            @image_extralarge = node.content
          when 'mega'
            @image_mega = node.content
          else
            raise NotImplementedError, "Image size '#{node['size'].to_s}' not supported."
        end #^ case
      end
    end
    
    # Return the URL to the specified image size.
    #
    # If the URL to the given image size is not known and a 
    # 'load_info'-function is defined, it will be called.
    def image(which=:small)
      which = which.to_s
      raise ArgumentError unless ['small', 'medium', 'large', 'extralarge',
        'mega'].include?(which)      
      img_url = instance_variable_get("@image_#{which}")
      if img_url.nil? && respond_to?(:load_info) 
        load_info 
        img_url = instance_variable_get("@image_#{which}")
      end
      img_url
    end
  end
end
