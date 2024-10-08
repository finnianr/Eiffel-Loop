note
	description: "[
		Extended access control class ${STRING_HANDLER} with commonly used
		string type query functions.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-06 11:28:21 GMT (Sunday 6th October 2024)"
	revision: "5"

deferred class
	EL_STRING_HANDLER

inherit
	STRING_HANDLER
		undefine
			copy, default_create, is_equal, out
		end

feature {NONE} -- Implementation

	is_zstring (general: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := {ISE_RUNTIME}.dynamic_type (general) = ZSTRING_type_id
		end

	string_storage_type (general: READABLE_STRING_GENERAL): CHARACTER
		-- character code representing number of bytes per character in string `general'
		-- 'X' means an indeterminate number for ZSTRING type
		do
			if general.is_string_8 then
				Result := '1' -- bytes

			elseif {ISE_RUNTIME}.dynamic_type (general) = ZSTRING_type_id then
				Result := 'X'
			else
				Result := '4' -- bytes
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

	ZSTRING_type_id: INTEGER
		once
			Result := ({ZSTRING}).type_id
		end
end