note
	description: "[
		Sort a string conforming to ${READABLE_STRING_GENERAL} into a tuple slot
		of the appropiate string_storage_type
	]"
	notes: "[
		Would this would have better performance if a class was used instead of a tuple ?
		Possibly !
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-15 10:09:50 GMT (Monday 15th April 2024)"
	revision: "3"

class
	STRING_TYPE_SORTER

inherit
	ANY

	EL_SHARED_CLASS_ID

feature -- Access

	frozen set_from (general: READABLE_STRING_GENERAL)
		-- allocate `general' into a `Once_tuple' position according to the string_storage_type
		do
			readable_8 := Void; readable_32 := Void; readable_z := Void

			string_storage_type := Class_id.string_storage_type (general)
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