# encoding: utf-8

require 'digest/md5'
require 'net/https'
require 'nokogiri'
require 'uri'

# Only set KCODE in Ruby 1.8.X, not in 1.9.X as it is deprecated
if RUBY_VERSION =~ /1\.8\.[0-9]/ then
  $KCODE = 'u' 
end


module Scrobbler
 
  API_URL     = 'http://ws.audioscrobbler.com/'
  
  class Base
    
    # By default, there is no cache
    @@cache = []
    
    def Base.add_cache(cache)
      @@cache << cache
    end
    
    # Set the default API key.
    #
    # This key will be used by all Scrobbler classes and objects.
    #
    # @param [String] api_key The default API key.
    # @return [nil]
    def Base.api_key=(api_key) 
      @@api_key = api_key
    end
  
    # Set the default API secret.
    #
    # This secret will be used by all Scrobbler classes and objects.
    #
    # @param [String] secret The default API secret.
    # @return [nil]
    def Base.secret=(secret)
      @@secret = secret
    end
  
    # Clean up a URL parameter.
    #
    # @param [String, Symbol] param The parameter which needs cleanup.
    # @return [String]
    def Base.sanitize(param)
      URI.escape(param.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end
  
    # Initiate a API and parse it.
    #
    # @param [String,Symbol] api_method The API method to call.
    # @param [String,Symbol] parent The parent node to inspect.
    # @param [Class,String,Symbol] element The name of the node to turn into objects.
    # @param [Hash<String,Symbol>] parameters The parameters for the method call.
    # @return [Array<Scrobbler::Base>]
    def Base.get(api_method, parent, element, parameters = {})
      scrobbler_class = element
      element = element.to_s.sub("Scrobbler::","").downcase
      doc = request(api_method, parameters)
      elements = []
      doc.root.children.each do |child|
          next unless child.name == parent.to_s
          child.children.each do |child2|
              next unless child2.name == element
              elements << scrobbler_class.new_from_libxml(child2)
          end
      end
      elements
    end

    # Execute a request to the Audioscrobbler webservice
    #
    # @param [String,Symbol] api_method The method which shall be called.
    # @param [Hash] parameter The parameters passed as URL params.
    # @return [LibXML::XML::Document]
    def Base.post_request(api_method, parameters = {})
      Base.request(api_method, parameters, 'post')
    end
  
    # Execute a request to the Audioscrobbler webservice
    #
    # @param [String,Symbol] api_method The method which shall be called.
    # @param [Hash] parameter The parameters passed as URL params.
    # @param [String] request_method The HTTP verb to be used.
    # @return [LibXML::XML::Document]
    def Base.request(api_method, parameters = {}, request_method = 'get')
      raise ArgumentError unless [String, Symbol].member?(api_method.class)
      raise ArgumentError unless parameters.kind_of?(Hash)
  
      parameters = {:signed => false}.merge(parameters)
      parameters['api_key'] = @@api_key
      parameters['method'] = api_method.to_s
      check_cache = false
      paramlist = []
      # Check if we want a signed call and pop :signed
      if parameters.delete :signed
        #1: Sort alphabetically
        params = parameters.sort{|a,b| a.at(0).to_s<=>b.at(0).to_s}
        #2: concat them into one string
        str = params.join('')
        #3: Append secret
        str = str + @@secret
        #4: Make a md5 hash
        md5 = Digest::MD5.hexdigest(str)
        params << [:api_sig, md5]
        params.each do |a|
          paramlist << "#{sanitize(a.at(0))}=#{sanitize(a.at(1))}"
        end
      else
        if request_method == 'get' then
          check_cache = true
        end
        parameters.each do |key, value|
          paramlist << "#{sanitize(key)}=#{sanitize(value)}"
        end
      end
      
      # Check if we could read from cache
      xml = nil
      if check_cache then
        @@cache.each do |cache|
          if cache.has?(parameters)
            xml = cache.get(parameters)
            break
          end
        end
      end
      
      # Fetch the http answer if cache was empty
      if xml.nil? then
        url = URI.join(API_URL, "/2.0/?#{paramlist.join('&')}")
        case request_method
          when "get"
            req = Net::HTTP::Get.new(url.request_uri)
          when "post"
            req = Net::HTTP::Post.new(url.request_uri)
        end
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = (url.port == 443)
        xml = http.start() do |conn| 
          conn.request(req)
        end
        xml = xml.body
      end
      
      # Process it
      doc = Nokogiri::XML(xml) do |config|
        config.noent.noblanks.nonet
      end
      
      # Write to cache
      if check_cache then
        @@cache.each do |cache|
          if cache.writable? then
            cache.set(xml, parameters)
          end
        end
      end
            
      doc
    end
    
    # Load information into instance variables.
    #
    # @param [Hash<String,Symbol>] data Each entry will be stored as a variable.
    # @return [nil]
    def populate_data(data = {})
      data.each do |key, value|
        instance_variable_set("@#{key.to_s}", value)
      end
    end
  
    # Execute a request to the Audioscrobbler webservice
    #
    # @param [String,Symbol] api_method The method which shall be called.
    # @param [Hash] parameter The parameters passed as URL params.
    # @return [LibXML::XML::Document]
    def request(api_method, parameters = {}, request_method = 'get')
      Base.request(api_method, parameters, request_method)
    end
  
    # Call a API method
    #
    # @param [String,Symbol] api_method The method which shall be called.
    # @param [Hash] params The parameters passed as URL params.
    # @param [String,Symbol] parent the parent XML node to look for.
    # @param [Class,String,Symbol] element The xml node name which shall
    #   be converted into an object.
    # @return [Array]
    def call(api_method, parent, element, params)
      Base.get(api_method, parent, element, params)
    end
  end # class Base
end # module Scrobbler
