note
	description: "[
		Abstraction to select implementations of ${EL_EXTENDED_READABLE_STRING_I} and
		${EL_EXTENDED_STRING_GENERAL} according to string argument type.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-20 15:28:33 GMT (Sunday 20th April 2025)"
	revision: "1"

deferred class
	EL_EXTENDED_STRING_SELECTION

inherit
	EL_STRING_HANDLER

feature {NONE} -- Mutable strings

	super_32 (str: STRING_32): EL_STRING_32
		do
			Result := shared_super_32
			Result.share (str)
		end

	super_8 (str: STRING_8): EL_STRING_8
		do
			Result := shared_super_8
			Result.share (str)
		end

	super_z (str: ZSTRING): EL_EXTENDED_ZSTRING
		do
			Result := shared_super_z
			Result.share (str)
		end

feature {NONE} -- General strings

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
					Result := shared_super_8

				when 'X' then
					Result := shared_super_z
			else
				Result := shared_super_32
			end
			Result.share (str)
		end


feature {NONE} -- Deferred

	shared_super_32: EL_STRING_32
		deferred
		end

	shared_super_8: EL_STRING_8
		deferred
		end

	shared_super_z: EL_EXTENDED_ZSTRING
		deferred
		end

end