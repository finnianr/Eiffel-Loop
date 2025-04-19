note
	description: "${EL_IMMUTABLE_STRING_8_LIST} encoded as UTF-8"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-19 15:09:03 GMT (Saturday 19th April 2025)"
	revision: "6"

class
	EL_IMMUTABLE_UTF_8_LIST

inherit
	EL_IMMUTABLE_STRING_8_LIST
		redefine
			item_index_of, less_than
		end

	EL_UTF_8_CONVERTER_I

	EL_SHARED_UTF_8_SEQUENCE

create
	make, make_empty

feature -- Measurement

	item_index_of (uc: CHARACTER_32): INTEGER
		local
			index_lower, index_upper: INTEGER
		do
			if attached Character_area_8.get (item, $index_lower, $index_upper) as l_area then
				Result := Utf_8_sequence.character_index_of (uc, l_area, index_lower, index_upper)
			end
		end

feature {NONE} -- Implementation

	less_than (u, v: IMMUTABLE_STRING_8): BOOLEAN
		local
			u_index, v_index, u_count, v_count: INTEGER
			u_area, v_area: SPECIAL [CHARACTER]
		do
			if attached Utf_8_sequence as utf_8 then
				u_area := Character_area_8.get_lower (u, $u_index)
				u_count := unicode_count (u)

				v_area := Character_area_8.get_lower (v, $v_index)
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