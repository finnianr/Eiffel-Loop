note

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-04 12:14:07 GMT (Friday 4th October 2024)"
	revision: "5"

class
	STRING_TYPE_SORTER

inherit
	ANY

	EL_STRING_HANDLER
		rename
			string_storage_type as new_string_storage_type
		end

feature -- Access

	frozen set_from (general: READABLE_STRING_GENERAL)
		-- allocate `general' into a `Once_tuple' position according to the string_storage_type
		do
			readable_8 := Void; readable_32 := Void; readable_z := Void

			string_storage_type := new_string_storage_type (general)
			inspect string_storage_type
				when '1' then
					if attached {READABLE_STRING_8} general as str_8 then
						readable_8 := str_8
					end
				when '4' then
					if attached {READABLE_STRING_32} general as str_32 then
						readable_32 := str_32
					end
				when 'X' then
					if attached {EL_READABLE_ZSTRING} general as zstr then
						readable_z := zstr
					end
			end
		end

feature -- Access

	readable_32: READABLE_STRING_32

	readable_8: READABLE_STRING_32

	readable_z: EL_READABLE_ZSTRING

	string_storage_type: CHARACTER

end