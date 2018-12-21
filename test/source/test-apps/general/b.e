note
	description: "B"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "3"

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
