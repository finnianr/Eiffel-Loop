note
	description: "[
		Sets values in `EL_ZSTRING_HASH_TABLE [ZSTRING]' operand in `make' routine argument tuple
		Values are set for existing keys which match a command line argument.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-25 11:35:23 GMT (Friday 25th January 2019)"
	revision: "4"

class
	EL_ZSTRING_TABLE_OPERAND_SETTER

inherit
	EL_MAKE_OPERAND_SETTER [EL_ZSTRING_HASH_TABLE [ZSTRING]]
		redefine
			set_operand
		end

feature {NONE} -- Implementation

	set_operand (i: INTEGER)
		do
			if attached {like value} make_routine.operands.item (i) as args_table then
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
