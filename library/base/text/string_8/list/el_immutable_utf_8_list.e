note
	description: "${EL_IMMUTABLE_STRING_8_LIST} encoded as UTF-8"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "2"

class
	EL_IMMUTABLE_UTF_8_LIST

inherit
	EL_IMMUTABLE_STRING_8_LIST
		redefine
			item_index_of, less_than
		end

	EL_UTF_8_CONVERTER
		export
			{NONE} all
		undefine
			copy, is_equal
		end

	EL_SHARED_STRING_8_CURSOR; EL_SHARED_UTF_8_SEQUENCE

create
	make, make_empty

feature -- Measurement

	item_index_of (uc: CHARACTER_32): INTEGER
		do
			if attached cursor_8 (item) as c8 then
				Result := Utf_8_sequence.character_index_of (uc, c8.area, c8.area_first_index, c8.area_last_index)
			end
		end

feature {NONE} -- Implementation

	less_than (u, v: IMMUTABLE_STRING_8): BOOLEAN
		local
			u_index, v_index, u_count, v_count: INTEGER
			u_area, v_area: SPECIAL [CHARACTER]
		do
			if attached Utf_8_sequence as utf_8 then
				if attached cursor_8 (u) as c8 then
					u_area := c8.area; u_index := c8.area_first_index
				end
				u_count := unicode_count (u)

				if attached cursor_8 (v) as c8 then
					v_area := c8.area; v_index := c8.area_first_index
				end
				v_count := unicode_count (v)

				if u_count = v_count then
					Result := utf_8.strict_comparison (u_area, v_area, v_index, u_index, v_count) > 0
				else
					if u_count < v_count then
						Result := utf_8.strict_comparison (u_area, v_area, v_index, u_index, u_count) >= 0
					else
						Result := utf_8.strict_comparison (u_area, v_area, v_index, u_index, v_count) > 0
					end
				end
			end
		end

end