note
	description: "Unix implemenation of interface [$source IL_STRING_SETTER_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-17 11:35:19 GMT (Tuesday 17th March 2020)"
	revision: "2"

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
