note
	description: "Common class type identifiers accesible via [$source EL_SHARED_CLASS_ID]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-23 10:28:44 GMT (Wednesday 23rd December 2020)"
	revision: "3"

class
	EL_CLASS_TYPE_ID_ENUM

inherit
	EL_TYPE_ID_ENUMERATION
		rename
			String_8 as Mod_string_8
		end

create
	make

feature -- String types

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

	DATE_TIME: INTEGER

	EL_MAKEABLE: INTEGER

	TUPLE: INTEGER

end