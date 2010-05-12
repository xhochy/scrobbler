require 'digest/md5'
require 'nokogiri'

$KCODE = 'u'

module Scrobbler
 
  API_URL     = 'http://ws.audioscrobbler.com/'
  
  class Base
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
  
    # Get a HTTP/REST connection to the webservice.
    #
    # @return [REST::Connection]
    def Base.connection
      @connection ||= REST::Connection.new(API_URL)
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
        parameters.each do |key, value|
          paramlist << "#{sanitize(key)}=#{sanitize(value)}"
        end
      end
      url = "/2.0/?#{paramlist.join('&')}"
      xml = self.connection.send(request_method, url)
      doc = Nokogiri::XML(xml) do |config|
        config.noent.noblanks.nonet
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
