note
	description: "ID3 version 2.x tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "22"

class
	TL_ID3_V2_TAG

inherit
	TL_ID3_TAG
		rename
			field_text as frame_text,
			set_field_text as set_frame_text
		undefine
			has_frame, album_artist, composer, beats_per_minute, duration, frame_text,
			set_album_artist, set_beats_per_minute, set_composer, set_duration, set_frame_text,
			remove_all, user_text_frame_list
		redefine
			make,
			comment_list, comment_with,
			header, picture, user_text_list, unique_id_list, user_text, unique_id,

			set_picture, set_unique_id, set_comment_with, set_user_text,

			has_comment_with, has_comment, has_user_text_with, has_unique_id_with, has_user_text, has_picture,
			has_unique_id,
			remove_all_unique_ids, remove_comment, remove_user_text, remove_unique_id, remove_picture
		end

	TL_ID3_V2_TAG_FRAME_ROUTINES

	TL_SHARED_STRING_ENCODING_ENUM

	TL_SHARED_ONCE_STRING_LIST

create
	make

feature {NONE} -- Initialization

	make (a_ptr: POINTER)
			--
		local
			found: BOOLEAN
		do
			Precursor (a_ptr)
			text_encoding := String_encoding.UTF_8
			-- Try and over-ride default encoding with actual encoding from file
			across Basic_text_frame_id_array as id until found loop
				if attached {TL_TEXT_IDENTIFICATION_ID3_FRAME} first_frame (id.item) as text then
					text_encoding := text.encoding
					found := True
				end
			end
			found := False
			language := Default_language
			across frame_list (Frame_id.COMM) as frame until found loop
				if attached {TL_COMMENTS_ID3_FRAME} frame as l_comment then
					Language_set.put (l_comment.language)
					if Language_set.found_item.count > 0 then
						language := Language_set.found_item
						found := True
					end
				end
			end
		end

feature -- Access

	album_artist: ZSTRING
		do
			Result := frame_text (Frame_id.TPE2)
		end

	beats_per_minute: INTEGER
		do
			Result := frame_integer (Frame_id.TBPM)
		end

	comment_list: EL_ARRAYED_LIST [TL_COMMENTS]
		do
			create Result.make (3)
			across frame_list (Frame_id.COMM) as frame loop
				if attached {TL_COMMENTS_ID3_FRAME} frame.item as l_frame then
					Result.extend (l_frame)
				end
			end
		end

	comment_with (description: READABLE_STRING_GENERAL): TL_COMMENTS
		do
			if Comments_table.has_key (self_ptr, description) then
				Result := Comments_table.found_item
			else
				create {TL_DEFAULT_COMMENTS} Result
			end
		end

	composer: ZSTRING
		do
			Result := frame_text (Frame_id.TCOM)
		end

	duration: INTEGER
		do
			Result := frame_integer (Frame_id.TLEN)
		end

	header: TL_ID3_V2_HEADER
		do
			create Result.make (cpp_header (self_ptr))
		end

	picture: TL_ID3_PICTURE
		do
			if attached {TL_PICTURE_ID3_FRAME} first_frame (Frame_id.apic) as frame then
				create Result.make_from_frame (frame)
			else
				create Result.make_default
			end
		end

	unique_id (owner: READABLE_STRING_GENERAL): TL_UNIQUE_FILE_IDENTIFIER
		-- unique identifier frames with owner equal to `owner'
		do
			if Unique_file_identifier_table.has_key (self_ptr, owner) then
				Result := Unique_file_identifier_table.found_item
			else
				create {TL_DEFAULT_UNIQUE_FILE_IDENTIFIER} Result
			end
		end

	unique_id_list: EL_ARRAYED_LIST [TL_UNIQUE_FILE_IDENTIFIER]
		do
			create Result.make (3)
			across frame_list (Frame_id.UFID) as ufid loop
				if attached {TL_UNIQUE_FILE_IDENTIFIER_ID3_FRAME} ufid.item as ufid_frame then
					Result.extend (ufid_frame)
				end
			end
		end

	user_text (a_description: READABLE_STRING_GENERAL): ZSTRING
		local
			list: like user_text_list
		do
			list := shared_user_text_list (a_description)
			if list.count = 1 then
				Result := list.first
			else
				Result := list.joined_lines
			end
		end

	user_text_list (a_description: READABLE_STRING_GENERAL): like shared_user_text_list
		do
			Result := shared_user_text_list (a_description).twin
		end

feature -- Status query

	has_comment: BOOLEAN
		do
			Result := frame_list (Frame_id.COMM).count > 0
		end

	has_comment_with (a_description: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := Comments_table.has (self_ptr, a_description)
		end

	has_picture: BOOLEAN
		do
			Result := has_frame (Frame_id.APIC)
		end

	has_unique_id: BOOLEAN
		do
			Result := has_frame (Frame_id.UFID)
		end

	has_unique_id_with (owner: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := Unique_file_identifier_table.has (self_ptr, owner)
		end

	has_user_text: BOOLEAN
		do
			Result := frame_list (Frame_id.TXXX).count > 0
		end

	has_user_text_with (a_description: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := User_text_table.has (self_ptr, a_description)
		end

feature -- Element change

	set_album_artist (a_album_artist: READABLE_STRING_GENERAL)
		do
			set_frame_text (Frame_id.TPE2, a_album_artist)
		ensure then
			set: album_artist.same_string_general (a_album_artist)
		end

	set_beats_per_minute (a_beats_per_minute: INTEGER)
		do
			set_frame_integer_value (Frame_id.TBPM, a_beats_per_minute)
		end

	set_comment_with (description, text: READABLE_STRING_GENERAL)
		-- set a comment identified by `description' with `text'
		local
			frame: TL_COMMENTS_ID3_FRAME
		do
			if Comments_table.has_key (self_ptr, description) then
				Comments_table.found_item.set_text (text)
			else
				create frame.make (description, text, language, text_encoding)
				add_frame (frame)
			end
		ensure then
			set: text.same_string (comment_with (description).text)
		end

	set_composer (a_composer: READABLE_STRING_GENERAL)
		do
			set_frame_text (Frame_id.TCOM, a_composer)
		ensure then
			set: composer.same_string_general (a_composer)
		end

	set_duration (a_duration: INTEGER)
		do
			set_frame_integer_value (Frame_id.TLEN, a_duration)
		end

	set_picture (a_picture: TL_ID3_PICTURE)
		do
			if attached {TL_PICTURE_ID3_FRAME} first_frame (Frame_id.APIC) as l_frame then
				remove_frame (l_frame)
			end
			add_frame (a_picture.to_frame)
		ensure then
			set: picture ~ a_picture
		end

	set_unique_id (owner: READABLE_STRING_GENERAL; identifier: STRING)
		local
			ufid: TL_UNIQUE_FILE_IDENTIFIER_ID3_FRAME
		do
			if Unique_file_identifier_table.has_key (self_ptr, owner) then
				Unique_file_identifier_table.found_item.set_identifier (identifier)
			else
				create ufid.make (owner, identifier)
				add_frame (ufid)
			end
		ensure then
			set: identifier.same_string (unique_id (owner).identifier)
		end

	set_user_text (a_description, a_text: READABLE_STRING_GENERAL)
		local
			frame: TL_USER_TEXT_IDENTIFICATION_ID3_FRAME
		do
			if User_text_table.has_key (self_ptr, a_description) then
				User_text_table.found_item.set_text (a_text)
			else
				create frame.make (a_description, a_text.split ('%N'), text_encoding)
				add_frame (frame)
			end
		ensure then
			set: a_text.same_string (user_text (a_description))
		end

feature -- Removal

	remove_all_unique_ids
		do
			remove_all (Frame_id.UFID)
		end

	remove_comment (a_description: READABLE_STRING_GENERAL)
		do
			if Comments_table.has_key (self_ptr, a_description) then
				remove_frame (Comments_table.found_item)
			end
		end

	remove_picture
		do
			remove_all (Frame_id.APIC)
		end

	remove_unique_id (owner: READABLE_STRING_GENERAL)
		do
			if Unique_file_identifier_table.has_key (self_ptr, owner) then
				remove_frame (Unique_file_identifier_table.found_item)
			end
		end

	remove_user_text (a_description: READABLE_STRING_GENERAL)
		do
			if User_text_table.has_key (self_ptr, a_description) then
				remove_frame (User_text_table.found_item)
			end
		end

feature -- Constants

	Type: INTEGER = 2

	Version: INTEGER = 2
		-- ID3 version number

feature {NONE} -- Internal attributes

	language: STRING
		-- language for comments

	text_encoding: NATURAL_8
		-- the text encoding to be used when creating new frames

feature {NONE} -- Constants

	Basic_text_frame_id_array: ARRAY [NATURAL_8]
		once
			Result := << Frame_id.TIT2, Frame_id.TALB, Frame_id.TPE1 >>
		end

	Comments_table: TL_COMMENTS_FRAME_TABLE
		once
			create Result
		end

	Default_language: STRING = "eng"

	Language_set: EL_HASH_SET [STRING]
		once
			create Result.make (5)
			Result.put (Default_language)
		end

	Unique_file_identifier_table: TL_UNIQUE_FILE_IDENTIFIER_FRAME_TABLE
		once
			create Result
		end

end