note
	description: "Test class B"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "6"

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