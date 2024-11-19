note
	description: "[
		Sets values in ${HASH_TABLE [ANY, READABLE_STRING_GENERAL]} operand in `make' routine argument tuple
		Values are set for existing keys which match a command line argument.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-19 10:57:54 GMT (Tuesday 19th November 2024)"
	revision: "11"

class
	EL_STRING_TABLE_OPERAND_SETTER

inherit
	EL_MAKE_OPERAND_SETTER [HASH_TABLE [ANY, READABLE_STRING_GENERAL]]
		redefine
			try_put_operand, value
		end

	EL_MODULE_CONVERT_STRING
		export
			{EL_FACTORY_CLIENT} Convert_string
		end

create
	make

feature {NONE} -- Implementation

	try_put_operand
		local
			value_type: TYPE [ANY]
		do
			if attached {like value} operands.item (index) as table_operand
				and then attached argument.command_line as command_line
			then
				table_operand.start
				if not table_operand.after then
					value_type := table_operand.item_for_iteration.generating_type
					across table_operand as arg loop
						if attached {READABLE_STRING_GENERAL} arg.key as key_general
							and then command_line.has_value (key_general)
						then
							if attached command_line.value (arg.key) as string_value then
								table_operand [key_general] := Convert_string.to_type (string_value, value_type)
							end
						end
					end
				end
			end
		end

	value (str: ZSTRING): HASH_TABLE [ANY, READABLE_STRING_GENERAL]
		do
			create Result.make (0)
		end

end