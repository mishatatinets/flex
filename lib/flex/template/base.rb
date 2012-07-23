module Flex
  class Template
    module Base

      def process_vars(vars)
        missing = @tags - vars.keys
        raise ArgumentError, "required variables #{missing.inspect} missing." \
              unless missing.empty?
        @partials.each do |k|
          raise MissingPartialError, "undefined #{k} partial template" \
                unless @host_flex.partials.has_key?(k)
          next if vars[k].nil?
          vars[k] = [vars[k]] unless vars[k].is_a?(Array)
          vars[k] = vars[k].map {|v| @host_flex.partials[k].interpolate(@variables.deep_dup, v)}
        end
        vars[:index] = vars[:index].join(',') if vars[:index].is_a?(Array)
        vars[:type]  = vars[:type].join(',')  if vars[:type].is_a?(Array)
        if vars[:page]
          vars[:params] ||= {}
          page = vars[:page].to_i
          page = 1 unless page > 0
          vars[:params][:from] = ((page - 1) * vars[:params][:size] || vars[:size] || 10).ceil
        end
        vars
      end

    end
  end
end