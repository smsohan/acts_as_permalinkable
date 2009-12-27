class PermalinkGenerator < Rails::Generator::NamedBase
  attr_accessor :migration_name, :permalink_field_name
 
  def initialize(args, options = {})
    super
    @class_name = args[0]
    @permalink_field_name = args[1] || 'permalink'
  end
 
  def manifest    
    file_name = generate_file_name
    @migration_name = file_name.camelize
    record do |m|
      m.migration_template "permalinkable_migration.rb.erb",
                           File.join('db', 'migrate'),
                           :migration_file_name => file_name
    end
  end 
  
  private 
  
  def generate_file_name
    "add_#{@permalink_field_name}_to_#{@class_name.underscore}"
  end
 
end
