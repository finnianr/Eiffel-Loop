note
	description: "[
		Sets values in ${EL_ZSTRING_HASH_TABLE [ZSTRING]} operand in `make' routine argument tuple
		Values are set for existing keys which match a command line argument.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-18 9:54:47 GMT (Monday 18th November 2024)"
	revision: "10"

class
	EL_ZSTRING_TABLE_OPERAND_SETTER

inherit
	EL_MAKE_OPERAND_SETTER [EL_ZSTRING_HASH_TABLE [ZSTRING]]
		redefine
			try_put_operand, value
		end

feature {NONE} -- Implementation

	try_put_operand
		do
			if attached {like value} operands.item (index) as args_table
				and then attached argument.command_line as command_line
			then
				across args_table as arg loop
					if command_line.has_value (arg.key) then
						args_table [arg.key] := command_line.value (arg.key)
					end
				end
			end
		end

	value (str: ZSTRING): EL_ZSTRING_HASH_TABLE [ZSTRING]
		do
			create Result
		end

end