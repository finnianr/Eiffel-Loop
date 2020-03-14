note
	description: "ID3 tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-14 18:58:26 GMT (Saturday 14th March 2020)"
	revision: "6"

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

	duration: INTEGER
		deferred
		end

	header: TL_ID3_HEADER
		do
			create Result
		end

	picture: TL_PICTURE_ID3_FRAME
		do
			create Result
		end

	title: ZSTRING
		deferred
		end

	version: INTEGER
		-- ID3 version number
		deferred
		end

feature -- Element change

	set_picture (a_picture: TL_ID3_PICTURE)
		deferred
		end

feature -- Status query

	is_default, is_version_zero: BOOLEAN
		-- `True' if type is `TL_ID3_V0_TAG'
		do
			Result := version = 0
		end

end
