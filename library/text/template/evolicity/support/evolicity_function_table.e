note
	description: "Evolicity object table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-13 20:07:20 GMT (Thursday 13th March 2025)"
	revision: "10"

class
	EVOLICITY_FUNCTION_TABLE

inherit
	EL_STRING_8_TABLE [FUNCTION [ANY]]

	EL_MODULE_CONVERT_STRING

create
	default_create, make_assignments, make_equal, make, make_one

feature -- Access

	found_item_result (target: EVOLICITY_EIFFEL_CONTEXT; key: READABLE_STRING_8; function_args: EL_ARRAYED_LIST [ANY]): ANY
		require
			found_key: found
		do
			if attached found_item as function then
				function.set_target (target)
				if function.open_count = 0 then
					function.apply
					Result := function.last_result

				elseif function.open_count = function_args.count
					and then attached new_operands (target, key, function, function_args) as operands
					and then function.valid_operands (operands)
				then
					Result := function.item (operands)
				else
					Result := Invalid_operands_template #$ [function.open_count, generator, key]
				end
			end
		end

feature -- Status query

	valid_function_args (key: READABLE_STRING_8; function_args: EL_ARRAYED_LIST [ANY]): BOOLEAN
		do
			Result := has_key (key) implies found_item.open_count = function_args.count
		end

feature {NONE} -- Implementation

	new_operands (
		target: EVOLICITY_CONTEXT; key: READABLE_STRING_8; function: FUNCTION [ANY]; function_args: EL_ARRAYED_LIST [ANY]

	): TUPLE
		local
			info: EL_FUNCTION_INFO; type: TYPE [ANY]; value: ANY
		do
			create info.make (key, function.generating_type)
			Result := info.new_tuple_argument
			if attached info.argument_types as argument_types then
				across function_args as arg loop
					type := argument_types [arg.cursor_index]; value := arg.item
					if attached {EVOLICITY_VARIABLE_REFERENCE} value as variable
						and then attached target.context_item (variable.last_step, variable.arguments) as target_value
					then
						value := target_value
					end
					if value.generating_type ~ type then
						Result.put (value, arg.cursor_index)

					elseif attached {READABLE_STRING_GENERAL} value as general then
						Result.put (Convert_string.to_type (general, type), arg.cursor_index)
					end
				end
			end
		end

feature {NONE} -- Constants

	Invalid_operands_template: ZSTRING
		once
			Result := "Cannot set %S operands for: {%S}.%S"
		end
end