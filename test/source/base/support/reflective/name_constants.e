note
	description: "Readable string types"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-25 5:27:45 GMT (Monday 25th July 2022)"
	revision: "1"

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