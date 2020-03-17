note
	description: "[
		A default empty frame that can dispose of itself and should not be
		added to any tag frame list.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-15 11:21:31 GMT (Sunday 15th March 2020)"
	revision: "1"

class
	TL_DEFAULT_ID3_TAG_FRAME

inherit
	TL_ID3_TAG_FRAME

	EL_OWNED_CPP_OBJECT
		undefine
			make_from_pointer
		end

	TL_ID3_PRIVATE_TAG_FRAME_CPP_API

create
	make

feature {NONE} -- Initialization

	make
		-- do not add to tag frame
		do
			make_from_pointer (cpp_new_empty)
		end

end
