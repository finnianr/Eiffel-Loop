note
	description: "Field that conforms to `STRING_GENERAL'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-02 12:08:05 GMT (Thursday 2nd April 2020)"
	revision: "11"

deferred class
	EL_REFLECTED_STRING [S -> STRING_GENERAL]

inherit
	EL_REFLECTED_REFERENCE [S]
		undefine
			reset, set_from_readable, set_from_string, write
		redefine
			to_string
		end

	EL_CACHEABLE_REFLECTED_REFERENCE [S]
		undefine
			reset, set_from_readable, set_from_string, write
		redefine
			to_string
		end

feature -- Access

	to_string (a_object: EL_REFLECTIVE): S
		do
			Result := value (a_object)
		end

end
