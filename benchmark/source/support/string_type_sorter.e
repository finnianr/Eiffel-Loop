note
	description: "[
		Sort a string conforming to ${READABLE_STRING_GENERAL} into a tuple slot
		of the appropiate character_bytes
	]"
	notes: "[
		Would this would have better performance if a class was used instead of a tuple ?
		Possibly !
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-13 15:11:53 GMT (Monday 13th November 2023)"
	revision: "1"

class
	STRING_TYPE_SORTER

feature -- Access

	frozen set_from (general: READABLE_STRING_GENERAL)
		-- allocate `general' into a `Once_tuple' position according to the character_bytes
		local
			byte_count, old_character_bytes: CHARACTER
		do
			byte_count := character_bytes; old_character_bytes := byte_count
			if general.is_string_32 then
				if attached {EL_READABLE_ZSTRING} general as zstr then
					readable_z := zstr; byte_count := 'X'

				elseif attached {READABLE_STRING_32} general as str_32 then
					readable_32 := str_32; byte_count := '4'
				end

			elseif attached {READABLE_STRING_8} general as str_8 then
				readable_8 := str_8; byte_count := '1'
			end
			if old_character_bytes /= byte_count then
				inspect old_character_bytes
					when '1' then
						readable_8 := Void

					when '4' then
						readable_32 := Void

					when 'X' then
						readable_z := Void
				else
				end
				character_bytes := byte_count
			end
		end

feature -- Access

	readable_32: READABLE_STRING_32

	readable_8: READABLE_STRING_32

	readable_z: EL_READABLE_ZSTRING

	character_bytes: CHARACTER

end