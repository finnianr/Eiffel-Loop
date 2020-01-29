note
	description: "Test class A"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-29 10:23:13 GMT (Wednesday 29th January 2020)"
	revision: "6"

class
	A

inherit
	EL_PRECURSOR_MAP

create
	make

feature {NONE} -- Initialization

	make
		do
			if not done ($make) then
				create str_1.make_empty
				set_done ($make)
			end
		end

feature -- Access

	str_1: STRING

	character: CHARACTER
		do
			Result := Internal_character
		end

feature {NONE} -- Constants

	done_mask_table: HASH_TABLE [NATURAL, POINTER]
		once
			create Result.make (32)
		end

	Internal_character: CHARACTER
		once
			Result := 'A'
		end
end
