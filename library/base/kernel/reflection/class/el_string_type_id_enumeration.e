note
	description: "String type identifier enumerations for inclusion in class ${EL_CLASS_TYPE_ID_ENUM}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-21 13:21:07 GMT (Monday 21st April 2025)"
	revision: "3"

class
	EL_STRING_TYPE_ID_ENUMERATION

feature -- Class aliases

	ZSTRING: INTEGER
		-- alias
		do
			Result := EL_ZSTRING
		end

feature -- Type sets

	immutable_string_types: SPECIAL [INTEGER]

	manifest_substring_types: SPECIAL [INTEGER]

	readable_string_32_types: SPECIAL [INTEGER]

	readable_string_8_types: SPECIAL [INTEGER]

	string_32_types: SPECIAL [INTEGER]

	zstring_types: SPECIAL [INTEGER]

feature -- Abstract Strings

	READABLE_STRING_32: INTEGER

	READABLE_STRING_8: INTEGER

	READABLE_STRING_GENERAL: INTEGER

	STRING_GENERAL: INTEGER

feature -- String types

	EL_EXTENDED_ZSTRING: INTEGER

	EL_FLOATING_ZSTRING: INTEGER

	EL_STRING_32: INTEGER

	EL_STRING_8: INTEGER

	EL_URI: INTEGER

	EL_URL: INTEGER

	EL_UTF_8_STRING: INTEGER

	EL_ZSTRING: INTEGER

	IMMUTABLE_STRING_32: INTEGER

	IMMUTABLE_STRING_8: INTEGER

	STRING_32: INTEGER

	STRING_8: INTEGER

	EL_WORD_TOKEN_LIST: INTEGER

feature -- Manifest substrings

	EL_MANIFEST_SUBSTRING_32: INTEGER

	EL_MANIFEST_SUBSTRING_8: INTEGER

	EL_MANIFEST_SUB_ZSTRING: INTEGER

end