note
	description: "Word case constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

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