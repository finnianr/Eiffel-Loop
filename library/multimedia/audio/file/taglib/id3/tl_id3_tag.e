note
	description: "ID3 tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-28 13:18:07 GMT (Monday   28th   October   2019)"
	revision: "3"

deferred class
	TL_ID3_TAG

inherit
	EL_CPP_OBJECT
		rename
			make_from_pointer as make
		end

feature -- Access

	album: TL_STRING
		do
			create Result.make (cpp_album (self_ptr))
		end

	artist: TL_STRING
		do
			create Result.make (cpp_artist (self_ptr))
		end

	comment: TL_STRING
		do
			create Result.make (cpp_comment (self_ptr))
		end

	title: TL_STRING
		do
			create Result.make (cpp_title (self_ptr))
		end

feature -- Status query

	is_default: BOOLEAN
		-- `True' if type is `TL_DEFAULT_ID3_TAG'
		do
		end

feature {NONE} -- Implementation

	cpp_album (tag: POINTER): POINTER
		deferred
		end

	cpp_artist (tag: POINTER): POINTER
		deferred
		end

	cpp_comment (tag: POINTER): POINTER
		deferred
		end

	cpp_title (tag: POINTER): POINTER
		deferred
		end
end
