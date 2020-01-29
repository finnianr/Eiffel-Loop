note
	description: "Universally unique identifier"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-29 13:46:55 GMT (Wednesday 29th January 2020)"
	revision: "14"

class
	EL_UUID

inherit
	UUID
		rename
			make_from_string as make_from_string_general
		undefine
			is_equal
		end

	EL_REFLECTIVELY_SETTABLE_STORABLE
		rename
			read_version as read_default_version
		undefine
			out
		redefine
			ordered_alphabetically
		end

	EL_MAKEABLE_FROM_STRING [STRING_8]
		rename
			make as make_from_string
		undefine
			out, is_equal
		end

create
	make_default, make, make_from_string_general, make_from_string, make_from_array

feature {NONE} -- Implementation

	make_from_string (str: STRING)
		do
			make_from_string_general (str)
		end

feature -- Access

	to_string: STRING
		do
			Result := out
		end

feature -- Constants

	Ordered_alphabetically: BOOLEAN = True
		-- read/write fields in alphabetical order

	Byte_count: INTEGER
		once
			Result := (32 + 16 * 3 + 64) // 8
		end

	Field_hash: NATURAL = 201719989

end
