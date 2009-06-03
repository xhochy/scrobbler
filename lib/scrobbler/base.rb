$KCODE = 'u'

module Scrobbler
  
  API_URL     = 'http://ws.audioscrobbler.com/'
  
class Base
    def Base.api_key=(api_key)
        @@api_key = api_key
    end

    def Base.connection
        @connection ||= REST::Connection.new(API_URL)
    end
    
    def Base.get(api_method, parent, element, parameters = {})
        scrobbler_class = "scrobbler/#{element.to_s}".camelize.constantize
        doc = request(api_method, parameters)
        elements = []
        doc.root.children.each do |child|
            next unless child.name == parent.to_s
            child.children.each do |child2|
                next unless child2.name == element.to_s
                elements << scrobbler_class.new_from_libxml(child2)
            end
        end
        elements
    end
    
    def Base.request(api_method, parameters = {})
        parameters['api_key'] = @@api_key
        parameters['method'] = api_method.to_s
        paramlist = []
        parameters.each do |key, value|
            good_key = URI.escape(key.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
            good_value = URI.escape(value.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
            paramlist << "#{good_key}=#{good_value}"
        end
        
        url = '/2.0/?' + paramlist.join('&')
        LibXML::XML::Document.string(self.connection.get(url))
    end
    
    private
      
      def populate_data(data = {})
        data.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end

      def get_response(api_method, instance_name, parent, element, params, force=false)
        if instance_variable_get("@#{instance_name}").nil? || force
            instance_variable_set("@#{instance_name}", Base.get(api_method, parent, element, params))
        end
        instance_variable_get("@#{instance_name}")
      end
end # class Base
end # module Scrobbler
