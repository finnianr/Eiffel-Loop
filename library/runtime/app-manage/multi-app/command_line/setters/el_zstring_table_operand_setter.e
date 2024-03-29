note
	description: "[
		Sets values in ${EL_ZSTRING_HASH_TABLE [ZSTRING]} operand in `make' routine argument tuple
		Values are set for existing keys which match a command line argument.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "9"

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
			if attached {like value} operands.item (index) as args_table then
				across args_table as arg loop
					if Args.has_value (arg.key) then
						args_table [arg.key] := Args.value (arg.key)
					end
				end
			end
		end

	value (str: ZSTRING): EL_ZSTRING_HASH_TABLE [ZSTRING]
		do
			create Result
		end

end