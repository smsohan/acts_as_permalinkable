module ActiveRecord
  module Acts
    module Permalinkable
      def self.included(base)
        base.send :extend, ClassMethods
      end

      module ClassMethods

        def acts_as_permalinkable(options = {})
          send :cattr_accessor, :permalink_options
          self.permalink_options = { :permalink_method => :name, :permalink_field_name => :permalink, :length => 200 }
          self.permalink_options.update(options) if options.is_a?(Hash)

          send :include, InstanceMethods
          send :after_create, :generate_permalink
        end
      
      end

      module InstanceMethods
        
        def generate_permalink
          dashed_text = permalinkable_text.gsub(/[^[:alnum:]]/, ' ').strip.gsub(/\W(\W)*/, '-')
          send "#{permalink_options[:permalink_field_name].to_s}=", dashed_text[0..permalink_options[:length]].downcase
          self.save!
        end
        
        def permalinkable_text
          self.id.to_s + ' ' + (self.send(permalink_options[:permalink_method]) || '')
        end
        
        def to_param
          existing_permalink = send(permalink_options[:permalink_field_name])
          (existing_permalink.present? && existing_permalink) || id.to_s
        end
          
      end
      
    end
  end
end