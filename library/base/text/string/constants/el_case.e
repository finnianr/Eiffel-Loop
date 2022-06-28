note
	description: "Word case constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-25 13:42:36 GMT (Saturday 25th June 2022)"
	revision: "1"

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

	Title: NATURAL = 2

	Upper: NATURAL = 3

	Valid: ARRAY [NATURAL]
		once
			Result := << Default, Lower, Title, Upper >>
		end

end