note
	description: "Readable string types"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-01 9:28:29 GMT (Wednesday 1st November 2023)"
	revision: "6"

class
	NAME_CONSTANTS

inherit
	ANY
		undefine
			default_create, is_equal
		end

	EL_REFLECTIVE_STRING_CONSTANTS
		rename
			foreign_naming as eiffel_naming
		end

feature -- Access

	string_8: STRING_8

	immutable_string_8: IMMUTABLE_STRING_8
end