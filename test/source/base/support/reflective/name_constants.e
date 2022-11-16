note
	description: "Readable string types"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	NAME_CONSTANTS

inherit
	EL_REFLECTIVE_STRING_CONSTANTS
		rename
			foreign_naming as eiffel_naming
		end

feature -- Access

	string_8: STRING_8

	immutable_string_8: IMMUTABLE_STRING_8
end