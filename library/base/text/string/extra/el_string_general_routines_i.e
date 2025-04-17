note
	description: "[
		Convert instances of ${ZSTRING} to and from ${STRING_32} or ${STRING_8}.
	]"
	notes: "[
		The necessity of these routines is because the routine ${ZSTRING}.z_code 
		implements ${READABLE_STRING_GENERAL}.code and for a small subset of characters
		the returned code is not the same as Unicode.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-17 15:02:30 GMT (Thursday 17th April 2025)"
	revision: "23"

deferred class
	EL_STRING_GENERAL_ROUTINES_I

inherit
	EL_STRING_HANDLER

feature {NONE} -- Implementation

	ZSTRING (general: READABLE_STRING_GENERAL): ZSTRING
		-- similar idea to putting: {STRING_32} "My unicode string"
		-- hence recommended to use upper-case
		do
			create Result.make_from_general (general)
		end

	as_readable_string_32 (general: READABLE_STRING_GENERAL): READABLE_STRING_32
		do
			if general.is_string_32 and then attached {READABLE_STRING_32} general as str_32 then
				Result := str_32
			else
				Result := general.to_string_32
			end
		end

	as_readable_string_8 (general: READABLE_STRING_GENERAL): READABLE_STRING_8
		do
			if general.is_string_8 and then attached {READABLE_STRING_8} general as str_8 then
				Result := str_8
			else
				Result := general.to_string_8
			end
		end

	as_zstring (general: READABLE_STRING_GENERAL): ZSTRING
		-- cast `general' to type `ZSTRING' if possible or else create a new `ZSTRING'
		do
			if conforms_to_zstring (general) and then attached {ZSTRING} general as z_str then
				Result := z_str
			else
				create Result.make_from_general (general)
			end
		end

	is_ascii_string_8 (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if str conforms to `READABLE_STRING_8' and all characters are in ASCII range
		do
			if str.is_string_8 and then attached {READABLE_STRING_8} str as str_8 then
				Result := super_readable_8 (str_8).is_ascii
			end
		end

	split_adjusted (
		value_list: READABLE_STRING_GENERAL; separator: CHARACTER_32; adjustments: INTEGER

	): EL_SPLIT_ON_CHARACTER [READABLE_STRING_GENERAL, COMPARABLE]
		require
			valid_separator: value_list.is_string_8 implies separator.is_character_8
		do
			inspect string_storage_type (value_list)
				when '1' then
					if attached {READABLE_STRING_8} value_list as str_8 then
						Result := super_readable_8 (str_8).split_adjusted (separator.to_character_8, adjustments)
					end

				when 'X' then
					if attached {ZSTRING} value_list as str_z then
						Result := super_z (str_z).split_adjusted (separator, adjustments)
					end
			else
				if attached {READABLE_STRING_32} value_list as str_32 then
					Result := super_readable_32 (str_32).split_adjusted (separator, adjustments)
				end
			end
		end

	super_32 (str: STRING_32): EL_STRING_32
		do
			Result := Shared_super_32
			Result.share (str)
		end

	super_8 (str: STRING_8): EL_STRING_8
		do
			Result := Shared_super_8
			Result.share (str)
		end

	super_general (str: STRING_GENERAL): EL_EXTENDED_STRING_GENERAL [COMPARABLE]
		-- modify `str' with routines from EL_EXTENDED_STRING_GENERAL
		do
			Result := super_general_by_type (str, string_storage_type (str))
		end

	super_general_by_type (str: STRING_GENERAL; type_code: CHARACTER): EL_EXTENDED_STRING_GENERAL [COMPARABLE]
		-- modify `str' with routines from EL_EXTENDED_STRING_GENERAL
		require
			valid_type_code: valid_string_storage_type (type_code)
		do
			inspect type_code
				when '1' then
					Result := Shared_super_8

				when 'X' then
					Result := shared_super_z
			else
				Result := Shared_super_32
			end
			Result.share (str)
		end

	super_readable_32 (str: READABLE_STRING_32): EL_READABLE_STRING_32
		do
			Result := Shared_super_readable_32
			Result.set_target (str)
		end

	super_readable_8 (str: READABLE_STRING_8): EL_READABLE_STRING_8
		do
			Result := Shared_super_readable_8
			Result.set_target (str)
		end

	super_readable_by_type (str: READABLE_STRING_GENERAL; type_code: CHARACTER): EL_EXTENDED_READABLE_STRING_I [COMPARABLE]
		require
			valid_type_code: valid_string_storage_type (type_code)
		do
			inspect type_code
				when '1' then
					Result := Shared_super_readable_8

				when 'X' then
					Result := shared_super_z
			else
				Result := Shared_super_readable_32
			end
			Result.set_target (str)
		end

	super_readable_general (str: READABLE_STRING_GENERAL): EL_EXTENDED_READABLE_STRING_I [COMPARABLE]
		do
			Result := super_readable_by_type (str, string_storage_type (str))
		end

	super_z (str: ZSTRING): EL_EXTENDED_ZSTRING
		do
			Result := shared_super_z
			Result.share (str)
		end

	to_ascii_string_8 (str: READABLE_STRING_GENERAL): detachable READABLE_STRING_8
		do
			if str.is_string_8 and then attached {READABLE_STRING_8} str as str_8
				and then super_readable_8 (str_8).is_ascii
			then
				Result := str_8
			end
		end

feature {NONE} -- Constants

	Shared_super_32: EL_STRING_32
		once
			create Result.make_empty
		end

	Shared_super_8: EL_STRING_8
		once
			create Result.make_empty
		end

	Shared_super_readable_32: EL_READABLE_STRING_32
		once
			create Result.make_empty
		end

	Shared_super_readable_8: EL_READABLE_STRING_8
		once
			create Result.make_empty
		end

	shared_super_z: EL_EXTENDED_ZSTRING
		once
			create Result.make_empty
		end

end