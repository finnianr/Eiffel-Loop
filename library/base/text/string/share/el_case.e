note
	description: "Word case constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-07 9:36:34 GMT (Monday 7th August 2023)"
	revision: "3"

class
	EL_CASE

inherit
	ANY
		rename
			default as default_object
		end

feature -- Constants

	Default: NATURAL = 0

	Lower: NATURAL = 1
		-- Flag 001

	Title: NATURAL = 4
		-- Flag 100

	Upper: NATURAL = 2
		-- Flag 010

	Valid: ARRAY [NATURAL]
		once
			Result := << Default, Lower, Title, Upper >>
		end

end