module Armg::AbstractMysqlAdapterExt
  def initialize_type_map(m)
    super
    %i[geometry point line_string polygon multi_point multi_line_string multi_polygon geometry_collection].each do |ty|
      m.register_type %r(^geometry)i, Armg::MysqlGeometry.new
    end
  end

  def indexes(*args, &block)
    is = super

    is.each do |i|
      if i.type == :spatial
        i.lengths = nil
      end
    end

    is
  end
end
