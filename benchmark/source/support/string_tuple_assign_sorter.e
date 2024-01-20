note
	description: "[
		Sort a string conforming to ${READABLE_STRING_GENERAL} into a tuple slot
		of the appropiate character_bytes
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "2"

frozen expanded class
	STRING_TUPLE_ASSIGN_SORTER

feature -- Access

	allocated (general: READABLE_STRING_GENERAL): like Once_tuple
		-- allocate `general' into a `Once_tuple' position according to the character_bytes
		local
			byte_count, old_byte_count: CHARACTER
		do
			Result := Once_tuple
			old_byte_count := Result.character_bytes
			if general.is_string_32 then
				if attached {EL_READABLE_ZSTRING} general as zstr then
					Result.Readable_Z := zstr; byte_count := 'X'

				elseif attached {READABLE_STRING_32} general as str_32 then
					Result.Readable_32 := str_32; byte_count := '4'
				end

			elseif attached {READABLE_STRING_8} general as str_8 then
				Result.Readable_8 := str_8; byte_count := '1'
			end
			if old_byte_count /= byte_count then
				if old_byte_count > '%U' then
					Result.put_reference (Void, to_index (old_byte_count))
				end
				Result.character_bytes := byte_count
			end
		end

feature {NONE} -- Implementation

	to_index (character_bytes: CHARACTER): INTEGER
		do
			inspect character_bytes
				when '1' then
					Result := 2

				when '4' then
					Result := 3

				when 'X' then
					Result := 4
			else
			end
		end

feature {NONE} -- Constants

	Once_tuple: TUPLE [
		character_bytes: CHARACTER; readable_8: READABLE_STRING_32; readable_32: READABLE_STRING_32
		readable_z: EL_READABLE_ZSTRING
	]
		once
			create Result
		end
end