note
	description: "A ${C_STRING_8} object but terminated with NULL character for callbacks into C."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2026-06-01 13:08:20 GMT (Monday 1st June 2026)"
	revision: "1"

class C_NULLED_STRING_8

inherit
	C_STRING_8
		rename
			make as make_sized
		export
			{NONE} all
			{STRING_HANDLER} area
		redefine
			to_string, debug_output, new_string
		end

create
	make, make_shared, make_empty, make_from_c

feature -- Initialization

	make (str: C_STRING_8)
		-- initialize from `str' and terminate with NULL character
		do
			make_sized (str.count + 1)
			area.memory_copy (str.area, str.count)
			put_character ('%U', str.count)
		ensure
			room_for_null: count = str.count + 1
			null_terminated: item (count) = '%U'
			same_string: str.to_string ~ to_string
		end

	make_from_c (ptr: POINTER)
		-- make shared  from null terminated C string
		do
			make_shared (ptr, c_string_8_length (ptr))
		end

feature -- Duplication

	new_string (str: STRING_8): like Current
		do
			create Result.make (str)
		end

feature -- Conversion

	to_string, debug_output: STRING_8
		do
			create Result.make_from_c (area)
		end

end

