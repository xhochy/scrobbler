require 'rubygems'
require 'cgi'
require 'libxml'

$KCODE = 'u'

module Scrobbler
  
  API_URL     = 'http://ws.audioscrobbler.com/'
  
  class Base
    def Base.api_key=(api_key)
        @@api_key = api_key
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
          paramlist <<  "#{CGI::escape(key.to_s)}=#{CGI::escape(value.to_s)}"
        end
        
        url = '/2.0/?' + paramlist.join('&')
        return LibXML::XML::Document.string(self.class.connection.get(url))
      end
      
      def populate_data(data = {})
        data.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end
      
      def get_response(api_method, instance_name, parent, element, parameters, force=false)
        scrobbler_class = "scrobbler/#{element.to_s}".camelize.constantize
        if instance_variable_get("@#{instance_name}").nil? || force
          doc = request(api_method, parameters)
          elements = []
          doc.root.children.each do |child|
            next unless child.name == parent
            child.children.each do |child2|
              next unless child2.name == element              
               elements << scrobbler_class.new_from_libxml(child2)
            end
          end
          instance_variable_set("@#{instance_name}", elements)
        end
        instance_variable_get("@#{instance_name}")
      end
  end
end
