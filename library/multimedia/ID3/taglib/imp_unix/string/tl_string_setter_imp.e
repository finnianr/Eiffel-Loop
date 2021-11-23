note
	description: "Unix implemenation of interface [$source TL_STRING_SETTER_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-23 18:45:01 GMT (Tuesday 23rd November 2021)"
	revision: "3"

class
	TL_STRING_SETTER_IMP

inherit
	TL_STRING_SETTER_I [NATURAL]
		rename
			extend_part as extend
		end

create
	make

end