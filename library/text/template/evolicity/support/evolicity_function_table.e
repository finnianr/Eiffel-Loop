note
	description: "Evolicity object table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-14 10:31:51 GMT (Friday 14th March 2025)"
	revision: "12"

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
				if function.open_count = variable_ref.arguments_count
					and then attached variable_ref.new_result (function) as new_result
				then
					Result := new_result
				else
					Result := target.invalid_operands_message (function, variable_ref)
				end
			end
		end

feature -- Contract Support

	valid_function_args (variable_ref: EVOLICITY_VARIABLE_REFERENCE; index: INTEGER): BOOLEAN
		do
			Result := has_key (variable_ref [index]) implies found_item.open_count = variable_ref.arguments_count
		end

end