note
	description: "Uuid"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "11"

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
			adjust_field_order
		end

	EL_MAKEABLE_FROM_STRING_8
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

	adjust_field_order (fields: EL_REFLECTED_FIELD_ARRAY)
		-- change order to: data_1, data_2 etc
		do
			fields.reorder (<<
				[4, -3] -- `date_1' left 3
			>>)
		end

feature -- Access

	to_string: STRING
		do
			Result := out
		end

feature -- Constants

	Byte_count: INTEGER
		once
			Result := (32 + 16 * 3 + 64) // 8
		end

	field_hash: NATURAL = 201719989

end
