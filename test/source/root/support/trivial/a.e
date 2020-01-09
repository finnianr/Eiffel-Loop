note
	description: "Test class A"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-08 17:57:02 GMT (Wednesday 8th January 2020)"
	revision: "4"

class
	A

feature -- Access

	character: CHARACTER
		do
			Result := Internal_character
		end

feature {NONE} -- Constants

	Internal_character: CHARACTER
		once
			Result := 'A'
		end
end
