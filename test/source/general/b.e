note
	description: "Summary description for {B}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-17 15:34:03 GMT (Monday 17th October 2016)"
	revision: "1"

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
