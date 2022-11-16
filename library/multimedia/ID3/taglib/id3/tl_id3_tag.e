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
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "17"

deferred class
	TL_ID3_TAG

inherit
	EL_CPP_OBJECT
		rename
			make_from_pointer as make
		end

	TL_BASIC_ID3_TAG_FIELDS

	TL_SHARED_FRAME_ID_ENUM

	EL_ZSTRING_CONSTANTS

feature -- Access

	album_artist, composer: ZSTRING
		do
			create Result.make_empty
		end

	beats_per_minute: INTEGER
		do
		end

	comment_list: EL_ARRAYED_LIST [TL_COMMENTS]
		do
			create Result.make_empty
		end

	comment_with (description: READABLE_STRING_GENERAL): TL_COMMENTS
		do
			create {TL_DEFAULT_COMMENTS} Result
		end

	duration: INTEGER
		do
		end

	field_text (a_frame_id: NATURAL_8): ZSTRING
		require
			valid_frame_id: valid_frame_id (a_frame_id)
		do
			create Result.make_empty
		end

	header: TL_ID3_HEADER
		do
			create Result
		end

	picture: TL_ID3_PICTURE
		do
			create Result.make_default
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

	unique_id_group_table: EL_FUNCTION_GROUP_TABLE [TL_UNIQUE_FILE_IDENTIFIER, ZSTRING]
		-- table of UFID's grouped by owner
		do
			create Result.make_from_list (agent {TL_UNIQUE_FILE_IDENTIFIER}.owner, unique_id_list)
		end

	user_text (a_description: READABLE_STRING_GENERAL): ZSTRING
		do
			create Result.make_empty
		end

	user_text_frame_list: EL_ARRAYED_LIST [TL_USER_TEXT_IDENTIFICATION_ID3_FRAME]
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

feature -- Status query

	has_comment: BOOLEAN
		do
		end

	has_comment_with (a_description: READABLE_STRING_GENERAL): BOOLEAN
		do
		end

	has_frame (a_frame_id: NATURAL_8): BOOLEAN
		require
			valid_code: valid_frame_id (a_frame_id)
		do
		end

	has_picture: BOOLEAN
		do
		end

	has_user_text: BOOLEAN
		do
		end

	has_unique_id: BOOLEAN
		do
		end

	has_unique_id_with (owner: READABLE_STRING_GENERAL): BOOLEAN
		do
		end

	has_user_text_with (description: READABLE_STRING_GENERAL): BOOLEAN
		do
		end

	is_default, is_version_zero: BOOLEAN
		-- `True' if type is `TL_ID3_V0_TAG'
		do
			Result := version = 0
		end

feature -- Element change

	set_album_artist, set_composer (text: READABLE_STRING_GENERAL)
		do
		end

	set_comment_with, set_user_text (description, text: READABLE_STRING_GENERAL)
		do
		end

	set_duration, set_beats_per_minute (n: INTEGER)
		do
		end

	set_field_text (a_frame_id: NATURAL_8; text: READABLE_STRING_GENERAL)
		do
		end

	set_picture (a_picture: TL_ID3_PICTURE)
		do
		end

	set_unique_id (owner: READABLE_STRING_GENERAL; identifier: STRING)
		do
		end

	set_year_from_days (days: INTEGER)
			--
		do
			set_year (days // Days_in_year)
		end

feature -- Removal

	remove_all (a_frame_id: NATURAL_8)
		-- remove all frames with `a_frame_id'
		require
			valid_frame: valid_frame_id (a_frame_id)
		do
		ensure
			removed: not has_frame (a_frame_id)
		end

	remove_all_unique_ids
		do
		end

	remove_comment (a_description: READABLE_STRING_GENERAL)
		do
		end

	remove_picture
		do
		end

	remove_unique_id (owner: READABLE_STRING_GENERAL)
		do
		end

	remove_user_text (a_description: READABLE_STRING_GENERAL)
		do
		end

feature -- Constants

	Days_in_year: INTEGER = 365

end