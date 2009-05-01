require 'rubygems'
require 'cgi'
require 'htmlentities'

$KCODE = 'u'

module Scrobbler
  
  API_URL     = 'http://ws.audioscrobbler.com/'
  API_VERSION = '1.0'
  
  class Base
    def Base.api_key=(api_key)
        @@api_key = api_key
    end

    @@coder = HTMLEntities.new
    
    # Decode HTML Entities so that we have plain strings in out code
    def Base.sanitize(string)
       @@coder.decode(string)
    end

    class << self
      def connection
        @connection ||= REST::Connection.new(API_URL)
      end
      
      def fetch_and_parse(resource)
        Hpricot::XML(connection.get(resource))
      end
      
    end
    
    private
      def request(api_method, parameters)
        parameters['api_key'] = @@api_key
        parameters['method'] = api_method.to_s
        paramlist = []
        parameters.each do |key, value|
          paramlist <<  "#{CGI::escape(key)}=#{CGI::escape(value)}"
        end
        
        self.class.fetch_and_parse('/2.0/?' + paramlist.join('&'))
      end

      def get_instance2(api_method, instance_name, element, parameters = {}, force=false)
        scrobbler_class = "scrobbler/#{element.to_s}".camelize.constantize
        if instance_variable_get("@#{instance_name}").nil? || force
          # Add the API key and the method to the parameters, they are always required
          parameters['api_key'] = @@api_key
          parameters['method'] = api_method.to_s

          # url-escape all parameters
          paramlist = []
          parameters.each do |key, value|
            paramlist <<  "#{CGI::escape(key)}=#{CGI::escape(value)}"
          end
          
          # Fetch data
          doc = self.class.fetch_and_parse('/2.0/?' + paramlist.join('&'));
          elements = (doc/element).inject([]) do |elements, el|
            elements << scrobbler_class.new_from_xml(el, doc);
            elements
          end
          instance_variable_set("@#{instance_name}", elements)
        end
        instance_variable_get("@#{instance_name}")
      end

      # in order for subclass to use, it must have api_path method
      def get_instance(api_method, instance_name, element, force=false)
        scrobbler_class = "scrobbler/#{element.to_s}".camelize.constantize
        if instance_variable_get("@#{instance_name}").nil? || force
          doc      = self.class.fetch_and_parse("#{api_path}/#{api_method}.xml")
          elements = (doc/element).inject([]) { |elements, el| elements << scrobbler_class.new_from_xml(el, doc); elements }
          instance_variable_set("@#{instance_name}", elements)
        end
        instance_variable_get("@#{instance_name}")
      end
  end
end
