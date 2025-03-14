note
	description: "Evolicity object table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-14 7:50:53 GMT (Friday 14th March 2025)"
	revision: "11"

class
	EVOLICITY_FUNCTION_TABLE

inherit
	EL_STRING_8_TABLE [FUNCTION [ANY]]

create
	default_create, make_assignments, make_equal, make, make_one

feature -- Access

	found_item_result (target: EVOLICITY_EIFFEL_CONTEXT; variable_ref: EVOLICITY_VARIABLE_REFERENCE; index: INTEGER): ANY
		require
			found_key: found
		do
			if attached found_item as function then
				function.set_target (target)
				if function.open_count = 0 then
					function.apply
					Result := function.last_result

				elseif function.open_count = variable_ref.arguments_count
					and then attached {EVOLICITY_FUNCTION_REFERENCE} variable_ref as function_reference
					and then attached function_reference.new_operands (function) as operands
					and then function.valid_operands (operands)
				then
					Result := function.item (operands)
				else
					Result := Invalid_operands_template #$ [function.open_count, generator, variable_ref [index]]
				end
			end
		end

feature -- Contract Support

	valid_function_args (variable_ref: EVOLICITY_VARIABLE_REFERENCE; index: INTEGER): BOOLEAN
		do
			Result := has_key (variable_ref [index]) implies found_item.open_count = variable_ref.arguments_count
		end

feature {NONE} -- Constants

	Invalid_operands_template: ZSTRING
		once
			Result := "Cannot set %S operands for: {%S}.%S"
		end
end