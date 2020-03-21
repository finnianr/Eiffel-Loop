note
	description: "ID3 tag that is owned by [$source TL_MPEG_FILE]"
	notes: "[
		**Tag Types**
		
			enum TagTypes {
				NoTags  = 0x0000, // Empty set.  Matches no tag types.
				ID3v1   = 0x0001, //! Matches ID3v1 tags.
				ID3v2   = 0x0002, //! Matches ID3v2 tags.
				APE     = 0x0004, //! Matches APE tags.
				AllTags = 0xffff //! Matches all tag types.
			};
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-21 18:42:20 GMT (Saturday 21st March 2020)"
	revision: "11"

deferred class
	TL_ID3_TAG

inherit
	EL_CPP_OBJECT
		rename
			make_from_pointer as make
		end

	TL_SHARED_FRAME_ID_ENUM

	TL_SHARED_ONCE_STRING

	EL_ZSTRING_CONSTANTS

feature -- ID3 fields

	album: ZSTRING
		deferred
		end

	album_artist, composer: ZSTRING
		do
			create Result.make_empty
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

	picture: TL_ID3_PICTURE
		do
			create Result.make_default
		end

	title: ZSTRING
		deferred
		end

feature -- Access

	comment_list: EL_ARRAYED_LIST [TL_COMMENTS]
		do
			create Result.make_empty
		end

	comment_with (description: READABLE_STRING_GENERAL): TL_COMMENTS
		do
			create {TL_DEFAULT_COMMENTS} Result
		end

	header: TL_ID3_HEADER
		do
			create Result
		end

	type: INTEGER
		deferred
		end

	unique_id (owner: READABLE_STRING_GENERAL): TL_UNIQUE_FILE_IDENTIFIER
		do
			create {TL_DEFAULT_UNIQUE_FILE_IDENTIFIER} Result
		end

	unique_id_list: EL_ARRAYED_LIST [TL_UNIQUE_FILE_IDENTIFIER]
		do
			create Result.make_empty
		end

	user_text (a_description: READABLE_STRING_GENERAL): ZSTRING
		do
			create Result.make_empty
		end

	user_text_list (a_description: READABLE_STRING_GENERAL): EL_ZSTRING_LIST
		do
			create Result.make_empty
		end

	version: INTEGER
		-- ID3 version number
		deferred
		end

feature -- Element change

	set_album (a_album: READABLE_STRING_GENERAL)
		deferred
		end

	set_album_artist (a_album_artist: READABLE_STRING_GENERAL)
		deferred
		end

	set_artist (a_artist: READABLE_STRING_GENERAL)
		deferred
		ensure
			set: version > 0 implies artist.same_string (a_artist)
		end

	set_composer (a_composer: READABLE_STRING_GENERAL)
		deferred
		end

	set_picture (a_picture: TL_ID3_PICTURE)
		deferred
		end

	set_title (a_title: READABLE_STRING_GENERAL)
		deferred
		end

	set_unique_id (owner: READABLE_STRING_GENERAL; identifier: STRING)
		do
		end

	set_user_text (a_description, a_text: READABLE_STRING_GENERAL)
		do
		end

feature -- Removal

	remove_user_text (a_description: READABLE_STRING_GENERAL)
		do
		end

feature -- Status query

	has_any_user_text: BOOLEAN
		do
		end

	has_user_text (a_description: READABLE_STRING_GENERAL): BOOLEAN
		do
		end

	is_default, is_version_zero: BOOLEAN
		-- `True' if type is `TL_ID3_V0_TAG'
		do
			Result := version = 0
		end

end
