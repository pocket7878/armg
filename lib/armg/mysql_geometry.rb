%i[geometry point line_string polygon multi_point multi_line_string multi_polygon geometry_collection].each do |ty|
  klass = Class.new(ActiveModel::Type::Value) do
    define_method :type do
      ty
    end

    def deserialize(value)
      if value.is_a?(::String)
        Armg.deserializer.deserialize(value)
      else
        value
      end
    end

    def serialize(value)
      if value.nil?
        nil
      else
        Armg.serializer.serialize(value)
      end
    end
  end
  ActiveModel::Type::Value.const_set("Armg::Mysql#{ty.to_s.self.split("_").map {|w| w[0] = w[0].upcase; w}.join}", klass)
end
