note
	description: "ID3 tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-11 18:28:13 GMT (Monday 11th November 2019)"
	revision: "5"

deferred class
	TL_ID3_TAG

inherit
	EL_CPP_OBJECT
		rename
			make_from_pointer as make
		end

	TL_SHARED_FRAME_ID_ENUM

	TL_SHARED_ONCE_STRING

feature -- Access

	album: ZSTRING
		deferred
		end

	artist: ZSTRING
		deferred
		end

	comment: ZSTRING
		deferred
		end

	title: ZSTRING
		deferred
		end

feature -- Status query

	is_default: BOOLEAN
		-- `True' if type is `TL_DEFAULT_ID3_TAG'
		do
		end

end
