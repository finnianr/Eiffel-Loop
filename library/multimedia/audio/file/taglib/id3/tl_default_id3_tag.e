note
	description: "A 'do nothing' default ID3 tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-28 13:18:20 GMT (Monday   28th   October   2019)"
	revision: "3"

class
	TL_DEFAULT_ID3_TAG

inherit
	TL_ID3_TAG
		redefine
			is_default
		end

feature -- Status query

	is_default: BOOLEAN = True

feature {NONE} -- Implementation

	cpp_album (tag: POINTER): POINTER
		do
		end

	cpp_artist (tag: POINTER): POINTER
		do
		end

	cpp_comment (tag: POINTER): POINTER
		do
		end

	cpp_delete (ptr: POINTER)
		do
		end

	cpp_title (tag: POINTER): POINTER
		do
		end

end
