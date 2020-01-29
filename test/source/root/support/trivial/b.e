note
	description: "Test class B"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-29 9:38:07 GMT (Wednesday 29th January 2020)"
	revision: "5"

class
	B

inherit
	A
		redefine
			Internal_character, make
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			if not done ($make) then
				Precursor
				set_done ($make)
			end
		end

feature {NONE} -- Constants

	Internal_character: CHARACTER
		once
			Result := 'B'
		end
end
