note
	description: "[
		Abstraction to select implementations of ${EL_EXTENDED_READABLE_STRING_I}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-20 15:31:37 GMT (Sunday 20th April 2025)"
	revision: "1"

deferred class
	EL_EXTENDED_READABLE_STRING_SELECTION

inherit
	EL_STRING_HANDLER

feature {NONE} -- Readable strings

	super_readable_32 (str: READABLE_STRING_32): EL_READABLE_STRING_32
		do
			Result := shared_super_readable_32
			Result.set_target (str)
		end

	super_readable_8 (str: READABLE_STRING_8): EL_READABLE_STRING_8
		do
			Result := shared_super_readable_8
			Result.set_target (str)
		end

	super_readable_z (str: ZSTRING): EL_EXTENDED_ZSTRING
		do
			Result := shared_super_readable_z
			Result.share (str)
		end

feature {NONE} -- General strings

	super_readable_by_type (str: READABLE_STRING_GENERAL; type_code: CHARACTER): EL_EXTENDED_READABLE_STRING_I [COMPARABLE]
		require
			valid_type_code: valid_string_storage_type (type_code)
		do
			inspect type_code
				when '1' then
					Result := shared_super_readable_8

				when 'X' then
					Result := shared_super_readable_z
			else
				Result := shared_super_readable_32
			end
			Result.set_target (str)
		end

	super_readable_general (str: READABLE_STRING_GENERAL): EL_EXTENDED_READABLE_STRING_I [COMPARABLE]
		do
			Result := super_readable_by_type (str, string_storage_type (str))
		end

feature {NONE} -- Deferred

	shared_super_readable_32: EL_READABLE_STRING_32
		deferred
		end

	shared_super_readable_8: EL_READABLE_STRING_8
		deferred
		end

	shared_super_readable_z: EL_EXTENDED_ZSTRING
		deferred
		end

end