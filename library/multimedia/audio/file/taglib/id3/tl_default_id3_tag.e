note
	description: "A 'do nothing' default ID3 tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-27 16:08:35 GMT (Sunday   27th   October   2019)"
	revision: "2"

class
	TL_DEFAULT_ID3_TAG

inherit
	TL_ID3_TAG

feature -- Access

	title: TL_STRING
		do
			create Result.make
		end

feature {NONE} -- Implementation

	cpp_delete (ptr: POINTER)
		do
		end
end
