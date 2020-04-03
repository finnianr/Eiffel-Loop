note
	description: "Basic ID3 tag fields"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-24 8:55:11 GMT (Tuesday 24th March 2020)"
	revision: "1"

deferred class
	TL_BASIC_ID3_TAG_FIELDS

inherit
	TL_ID3_TAG_CPP_API

	TL_SHARED_ONCE_STRING

feature -- Access

	album: ZSTRING
		do
			cpp_get_album (self_ptr, Once_string.self_ptr)
			Result := Once_string.to_string
		end

	artist: ZSTRING
		do
			cpp_get_artist (self_ptr, Once_string.self_ptr)
			Result := Once_string.to_string
		end

	comment: ZSTRING
		do
			cpp_get_comment (self_ptr, Once_string.self_ptr)
			Result := Once_string.to_string
		end

	genre: ZSTRING
		do
			cpp_get_genre (self_ptr, Once_string.self_ptr)
			Result := Once_string.to_string
		end

	title: ZSTRING
		do
			cpp_get_title (self_ptr, Once_string.self_ptr)
			Result := Once_string.to_string
		end

	track: INTEGER
		do
			Result := cpp_track (self_ptr)
		end

	year: INTEGER
		-- Recording time
		do
			Result := cpp_year (self_ptr)
		end

feature -- Element change

	set_album (a_album: READABLE_STRING_GENERAL)
		do
			Once_string.set_from_string (a_album)
			cpp_set_album (self_ptr, Once_string.self_ptr)
		ensure
			set: version > 0 implies a_album.same_string (album)
		end

	set_artist (a_artist: READABLE_STRING_GENERAL)
		do
			Once_string.set_from_string (a_artist)
			cpp_set_artist (self_ptr, Once_string.self_ptr)
		ensure
			set: version > 0 implies a_artist.same_string (artist)
		end

	set_comment (a_comment: READABLE_STRING_GENERAL)
		do
			Once_string.set_from_string (a_comment)
			cpp_set_comment (self_ptr, Once_string.self_ptr)
		ensure
			set: version > 0 implies a_comment.same_string (comment)
		end

	set_genre (a_genre: READABLE_STRING_GENERAL)
		do
			Once_string.set_from_string (a_genre)
			cpp_set_genre (self_ptr, Once_string.self_ptr)
		ensure
			set: version > 0 implies a_genre.same_string (genre)
		end

	set_title (a_title: READABLE_STRING_GENERAL)
		do
			Once_string.set_from_string (a_title)
			cpp_set_title (self_ptr, Once_string.self_ptr)
		ensure
			set: version > 0 implies a_title.same_string (title)
		end

	set_track (a_track: INTEGER)
		do
			cpp_set_track (self_ptr, a_track)
		ensure
			set: version > 0 implies a_track = track
		end

	set_year (a_year: INTEGER)
		do
			cpp_set_year (self_ptr, a_year)
		ensure
			set: version > 0 implies a_year = year
		end

feature {NONE} -- Implementation

	self_ptr: POINTER
		deferred
		end

	version: INTEGER
		deferred
		end
end
