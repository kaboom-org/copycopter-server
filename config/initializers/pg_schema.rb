schema_name = 'copycopter'

if !ActiveRecord::Base.connection.schema_exists?(schema_name)
  ActiveRecord::Base.connection.execute("CREATE SCHEMA #{schema_name}")
end

ActiveRecord::Base.connection.execute("SET search_path to #{schema_name}")
