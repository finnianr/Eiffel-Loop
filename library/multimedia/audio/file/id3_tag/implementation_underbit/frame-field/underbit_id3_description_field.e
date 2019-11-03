note
	description: "Underbit id3 description field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-15 11:36:08 GMT (Tuesday 15th October 2019)"
	revision: "6"

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
