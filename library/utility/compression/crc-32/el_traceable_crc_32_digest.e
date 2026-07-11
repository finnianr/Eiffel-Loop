note
	description: "[
		${EL_CRC_32_DIGEST} with indexed trace output on IO for debugging
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2026 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2026-07-09 20:15:00 GMT (Thursday 9th July 2026)"
	revision: "1"

class
	EL_TRACEABLE_CRC_32_DIGEST

inherit
	EL_CRC_32_DIGEST
		redefine
			add_bytes, add_characters, add_string
		end

feature -- Element change

	add_bytes (byte_array: POINTER; count: INTEGER)
		do
			Precursor (byte_array, count)
			put_digest_trace
		end

	add_characters (area: SPECIAL [CHARACTER]; lower, upper: INTEGER)
		do
			Precursor (area, lower, upper)
			put_digest_trace
		end

	add_string (str: STRING_8)
		do
			Precursor (str)
			put_digest_trace
		end

feature {NONE} -- Implementation

	put_digest_trace
		do
			index := index + 1
			IO.put_integer (index)
			IO.put_string (once ". ")
			IO.put_natural_64 (item)
			IO.put_new_line
		end

feature {NONE} -- Internal attributes

	index: INTEGER

end
