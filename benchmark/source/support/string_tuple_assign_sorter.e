note
	description: "[
		Sort a string conforming to ${READABLE_STRING_GENERAL} into a tuple slot
		of the appropiate storage_type
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-25 8:43:58 GMT (Sunday 25th August 2024)"
	revision: "4"

frozen expanded class
	STRING_TUPLE_ASSIGN_SORTER

inherit
	EL_EXPANDED_ROUTINES

	EL_STRING_HANDLER

feature -- Access

	allocated (general: READABLE_STRING_GENERAL): like Once_tuple
		-- allocate `general' into a `Once_tuple' position according to the storage_type
		local
			byte_count, old_byte_count: CHARACTER
		do
			Result := Once_tuple
			Result.readable_8 := Void; Result.readable_32 := Void; Result.readable_Z := Void

			Result.storage_type := string_storage_type (general)
			inspect Result.storage_type
				when '1' then
					if attached {READABLE_STRING_8} general as str_8 then
						Result.readable_8 := str_8
					end
				when '4' then
					if attached {READABLE_STRING_32} general as str_32 then
						Result.readable_32 := str_32
					end
				when 'X' then
					if attached {EL_READABLE_ZSTRING} general as z_str then
						Result.readable_z := z_str
					end
			end
		end

feature {NONE} -- Implementation

	to_index (storage_type: CHARACTER): INTEGER
		do
			inspect storage_type
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
		storage_type: CHARACTER; readable_8: READABLE_STRING_32; readable_32: READABLE_STRING_32
		readable_z: EL_READABLE_ZSTRING
	]
		once
			create Result
		end
end