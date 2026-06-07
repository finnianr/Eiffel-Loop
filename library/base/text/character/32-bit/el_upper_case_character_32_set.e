note
	description: "Set of ${CHARACTER_32} that are upper-case"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-27 10:45:17 GMT (Sunday 27th April 2025)"
	revision: "1"

once class
	EL_UPPER_CASE_CHARACTER_32_SET

inherit
	EL_SET [CHARACTER_32]

create
	make

feature -- Initialization

	make
		once ("PROCESS")
			do_nothing
		end

feature -- Status query

	has (c: CHARACTER_32): BOOLEAN
		-- `True' if `c' is a member of set of all upper case characters
		do
			Result := c.is_upper
		end

end
