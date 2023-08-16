note
	description: "Evolicity object table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-31 12:22:46 GMT (Monday 31st July 2023)"
	revision: "7"

class
	EVOLICITY_FUNCTION_TABLE

inherit
	EL_STRING_8_TABLE [FUNCTION [ANY]]

create
	default_create, make, make_equal, make_size

feature -- Access

	found_item_result (target: EVOLICITY_EIFFEL_CONTEXT; key: STRING; function_args: TUPLE): ANY
		require
			found_key: found
		do
			if attached found_item as function then
				function.set_target (target)
				if function.open_count = 0 then
					function.apply
					Result := function.last_result

				elseif function.valid_operands (function_args) then
					Result := function.flexible_item (function_args)
				else
					Result := Invalid_operands_template #$ [function.open_count, generator, key]
				end
			end
		end

feature -- Status query

	valid_function_args (key: STRING; function_args: TUPLE): BOOLEAN
		do
			Result := has_key (key) implies found_item.open_count = function_args.count
		end

feature {NONE} -- Constants

	Invalid_operands_template: ZSTRING
		once
			Result := "Cannot set %S operands for: {%S}.%S"
		end
end