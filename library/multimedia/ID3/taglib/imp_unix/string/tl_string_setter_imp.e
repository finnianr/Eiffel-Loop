note
	description: "Unix implemenation of interface ${TL_STRING_SETTER_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "5"

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