note
	description: "[
		Convert [$source ZSTRING] to [$source READABLE_STRING_GENERAL] as [$source STRING_32]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-18 12:52:29 GMT (Friday 18th August 2023)"
	revision: "1"

deferred class
	EL_STRING_GENERAL_ROUTINES

inherit
	ANY
		undefine
			copy, default_create, is_equal, out
		end

feature {NONE} -- Implementation

	as_zstring (general: READABLE_STRING_GENERAL): ZSTRING
		do
			if attached {ZSTRING} general as str then
				Result := str
			else
				create Result.make_from_general (general)
			end
		end

	new_zstring (general: READABLE_STRING_GENERAL): ZSTRING
		do
			create Result.make_from_general (general)
		end

	to_unicode_general (general: READABLE_STRING_GENERAL): READABLE_STRING_GENERAL
		do
			if attached {ZSTRING} general as zstr then
				Result := zstr.to_unicode
			else
				Result := general
			end
		end
end