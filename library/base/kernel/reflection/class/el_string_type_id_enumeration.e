note
	description: "String type identifier enumerations for inclusion in class ${EL_CLASS_TYPE_ID_ENUM}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-17 10:47:07 GMT (Monday 17th March 2025)"
	revision: "1"

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

	readable_string_32_types: SPECIAL [INTEGER]

	readable_string_8_types: SPECIAL [INTEGER]

feature -- Abstract Strings

	READABLE_STRING_32: INTEGER

	READABLE_STRING_8: INTEGER

	STRING_GENERAL: INTEGER

	READABLE_STRING_GENERAL: INTEGER

feature -- String types

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

end