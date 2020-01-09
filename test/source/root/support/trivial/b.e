note
	description: "Test class B"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-08 17:57:06 GMT (Wednesday 8th January 2020)"
	revision: "4"

class
	B

inherit
	A
		redefine
			Internal_character
		end

feature {NONE} -- Constants

	Internal_character: CHARACTER
		once
			Result := 'B'
		end
end
