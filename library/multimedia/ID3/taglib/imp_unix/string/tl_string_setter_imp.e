note
	description: "Unix implemenation of interface [$source TL_STRING_SETTER_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "4"

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