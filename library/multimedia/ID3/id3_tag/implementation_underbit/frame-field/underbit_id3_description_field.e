note
	description: "Underbit id3 description field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	UNDERBIT_ID3_DESCRIPTION_FIELD

inherit
	ID3_DESCRIPTION_FIELD

	UNDERBIT_ID3_STRING_FIELD
		undefine
			type
		end

create
	make

end