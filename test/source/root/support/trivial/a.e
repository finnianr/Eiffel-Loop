note
	description: "Test class A"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-23 7:59:17 GMT (Monday 23rd September 2024)"
	revision: "9"

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

	once_xxx: STRING
		once
			Result := "xxx"
		end

feature {NONE} -- Constants

	done_mask_table: EL_HASH_TABLE [NATURAL, POINTER]
		once
			create Result.make (32)
		end

	Internal_character: CHARACTER
		once
			Result := 'A'
		end
end