note
	description: "${EL_IMMUTABLE_STRING_8_LIST} encoded as UTF-8"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-15 17:47:13 GMT (Tuesday 15th April 2025)"
	revision: "5"

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
		do
			if attached super_readable_8 (item) as super then
				Result := Utf_8_sequence.character_index_of (uc, super.area, super.index_lower, super.index_upper)
			end
		end

feature {NONE} -- Implementation

	less_than (u, v: IMMUTABLE_STRING_8): BOOLEAN
		local
			u_index, v_index, u_count, v_count: INTEGER
			u_area, v_area: SPECIAL [CHARACTER]
		do
			if attached Utf_8_sequence as utf_8 then
				if attached super_readable_8 (u) as super then
					u_area := super.area; u_index := super.index_lower
				end
				u_count := unicode_count (u)

				if attached super_readable_8 (v) as super then
					v_area := super.area; v_index := super.index_lower
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