note
	description: "[
		Extended access control class ${STRING_HANDLER} with commonly used
		string type query functions.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-13 16:31:21 GMT (Sunday 13th April 2025)"
	revision: "6"

deferred class
	EL_STRING_HANDLER

inherit
	STRING_HANDLER
		undefine
			copy, default_create, is_equal, out
		end

feature {NONE} -- Implementation

	conforms_to_zstring (general: READABLE_STRING_GENERAL): BOOLEAN
		do
			if general.is_string_32 then
				Result := {ISE_RUNTIME}.dynamic_type (general) >= READABLE_ZSTRING_type_id
			end
		end

	string_storage_type (general: READABLE_STRING_GENERAL): CHARACTER
		-- character code representing number of bytes per character in string `general'
		-- 'X' means an indeterminate number for ZSTRING type
		do
			if general.is_string_8 then
				Result := '1' -- 1 byte per character

			elseif {ISE_RUNTIME}.dynamic_type (general) >= READABLE_ZSTRING_type_id then
				Result := 'X' -- 1 or 4 bytes per character

			else
				Result := '4' -- 4 bytes per character: STRING_32 etc
			end
		ensure
			valid_code: valid_string_storage_type (Result)
		end

feature -- Contract Support

	valid_string_storage_type (code: CHARACTER): BOOLEAN
		do
			inspect code
				when '1', '4', 'X' then
					Result := True
			else
			end
		end

feature {NONE} -- Constants

	READABLE_ZSTRING_type_id: INTEGER
		once ("PROCESS")
			Result := ({EL_READABLE_ZSTRING}).type_id
		end

end