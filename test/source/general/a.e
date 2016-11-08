note
	description: "Summary description for {A}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-17 15:33:47 GMT (Monday 17th October 2016)"
	revision: "1"

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
