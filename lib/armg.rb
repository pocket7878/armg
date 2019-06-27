require 'active_support/lazy_load_hooks'
require 'rgeo'
require 'armg/version'

ActiveSupport.on_load(:active_record) do
  require 'active_record/connection_adapters/abstract_mysql_adapter'
  require 'armg/utils'
  require 'armg/wkb_serializer'
  require 'armg/wkb_deserializer'
  require 'armg/wkt_serializer'
  require 'armg/wkt_deserializer'
  require 'armg/abstract_mysql_adapter_ext'
  require 'armg/mysql_geometry'
  require 'armg/table_definition_ext'
  require 'armg/armg'

  # Define Geometry Types
  geom_types = %i[geometry point line_string polygon multi_point multi_line_string multi_polygon geometry_collection]
  geom_types.each do |g|
    ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter::NATIVE_DATABASE_TYPES[g] = {name: g.to_s}
  end

  ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter.prepend(Armg::AbstractMysqlAdapterExt)
  # Register Types
  geom_types.each do |g|
    gname = g.to_s.self.split("_").map {|w| w[0] = w[0].upcase; w}.join
    ActiveRecord::Type.register(g, Armg::MysqlGeometry, adapter: :mysql2)
  end

  ActiveRecord::ConnectionAdapters::MySQL::TableDefinition.prepend(Armg::TableDefinitionExt)
  ActiveRecord::ConnectionAdapters::MySQL::Table.prepend(Armg::TableDefinitionExt)
end
