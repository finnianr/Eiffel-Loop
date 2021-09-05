note
	description: "Common class type identifiers accesible via [$source EL_SHARED_CLASS_ID]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-01 9:47:11 GMT (Wednesday 1st September 2021)"
	revision: "7"

class
	EL_CLASS_TYPE_ID_ENUM

inherit
	EL_TYPE_ID_ENUMERATION

create
	make

feature -- CHARACTER types

	CHARACTER_8: INTEGER

	CHARACTER_32: INTEGER

feature -- INTEGER types

	INTEGER_8: INTEGER

	INTEGER_16: INTEGER

	INTEGER_32: INTEGER

	INTEGER_64: INTEGER

feature -- NATURAL types

	NATURAL_8: INTEGER

	NATURAL_16: INTEGER

	NATURAL_32: INTEGER

	NATURAL_64: INTEGER

feature -- REAL types

	REAL_32: INTEGER

	REAL_64: INTEGER

feature -- String types

	IMMUTABLE_STRING_8: INTEGER

	STRING_8: INTEGER

	STRING_32: INTEGER

	EL_ZSTRING: INTEGER

	ZSTRING: INTEGER
		do
			Result := EL_ZSTRING
		end

feature -- Path types

	EL_FILE_PATH: INTEGER

	EL_DIR_PATH: INTEGER

	EL_PATH: INTEGER

feature -- Other types

	BOOLEAN: INTEGER

	EL_BOOLEAN_OPTION: INTEGER

	DATE_TIME: INTEGER

	EL_MAKEABLE: INTEGER

	TUPLE: INTEGER

feature -- Constants

	Unicode_types: ARRAY [INTEGER]
		-- types containing character data from the Unicode character set
		once
			Result := << CHARACTER_32, STRING_32, EL_ZSTRING, EL_FILE_PATH, EL_DIR_PATH >>
		end

	Character_data_types: ARRAY [INTEGER]
		-- types containing character data
		once
			Result := <<
				CHARACTER_8, CHARACTER_32, STRING_8, STRING_32, EL_ZSTRING, EL_FILE_PATH, EL_DIR_PATH
			>>
		end
end