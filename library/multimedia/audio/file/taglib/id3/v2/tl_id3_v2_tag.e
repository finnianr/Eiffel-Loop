note
	description: "ID3 version 2.x tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-21 19:53:15 GMT (Saturday 21st March 2020)"
	revision: "15"

class
	TL_ID3_V2_TAG

inherit
	TL_ID3_TAG
		export
			{TL_FRAME_TABLE} self_ptr
		redefine
			album_artist, unique_id_list, composer, comment_list, comment_with,
			header, picture, set_unique_id, user_text_list, user_text, unique_id,
			has_user_text, has_any_user_text, set_user_text, make, remove_user_text
		end

	TL_ID3_V2_TAG_CPP_API

	TL_SHARED_FRAME_ID_ENUM

	TL_SHARED_BYTE_VECTOR

	TL_SHARED_STRING_ENCODING_ENUM

	TL_SHARED_ONCE_STRING_LIST

	TL_SHARED_DEFAULT_FRAME

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
					if not Language_set.found_item.is_empty then
						language := Language_set.found_item
						found := True
					end
				end
			end
		end

feature -- ID3 fields

	album: ZSTRING
		do
			Result := frame_text (Frame_id.TALB)
		end

	album_artist: ZSTRING
		do
			Result := frame_text (Frame_id.TPE2)
		end

	artist: ZSTRING
		do
			Result := frame_text (Frame_id.TPE1)
		end

	comment: ZSTRING
		do
			cpp_get_comment (self_ptr, Once_string.self_ptr)
			Result := Once_string.to_string
		end

	composer: ZSTRING
		do
			Result := frame_text (Frame_id.TCOM)
		end

	duration: INTEGER
		do
			Result := frame_integer (Frame_id.TLEN)
		end

	picture: TL_ID3_PICTURE
		do
			if attached {TL_PICTURE_ID3_FRAME} first_frame (Frame_id.apic) as frame then
				create Result.make_from_frame (frame)
			else
				create Result.make_default
			end
		end

	title: ZSTRING
		do
			Result := frame_text (Frame_id.TIT2)
		end

feature -- Access

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
			if Comments_table.has_key (Current, description) then
				Result := Comments_table.found_item
			else
				create {TL_DEFAULT_COMMENTS} Result
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

	unique_id (owner: READABLE_STRING_GENERAL): TL_UNIQUE_FILE_IDENTIFIER
		-- unique identifier frames with owner equal to `owner'
		do
			if Unique_file_identifier_table.has_key (Current, owner) then
				Result := Unique_file_identifier_table.found_item
			else
				create {TL_DEFAULT_UNIQUE_FILE_IDENTIFIER} Result
			end
		end

feature -- Frames

	all_frames_list: EL_ARRAYED_LIST [TL_ID3_TAG_FRAME]
		do
			create Result.make (frame_count)
			across iterable_frames as frame loop
				Result.extend (frame.item)
			end
		end

	frame_integer (enum_code: NATURAL_8): INTEGER
		require
			valid_code: valid_frame_id (enum_code)
		do
			Result := filled_once_string (enum_code).to_integer
		end

	frame_text (enum_code: NATURAL_8): ZSTRING
		require
			valid_code: valid_frame_id (enum_code)
		do
			Result := filled_once_string (enum_code).to_string
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

feature -- Access

	header: TL_ID3_V2_HEADER
		do
			create Result.make (cpp_header (self_ptr))
		end

feature -- Measurement

	frame_count: INTEGER
		-- count of all frames
		do
			Result := cpp_frame_count (self_ptr)
		end

	frame_type_count (enum_code: NATURAL_8): INTEGER
		require
			valid_code: valid_frame_id (enum_code)
		do
			across frame_list (enum_code) as frame loop
				Result := Result + 1
			end
		end

feature -- Status query

	has_any_user_text: BOOLEAN
		do
			Result := frame_list (Frame_id.TXXX).count > 0
		end

	has_frame (enum_code: NATURAL_8): BOOLEAN
		require
			valid_code: valid_frame_id (enum_code)
		do
			Result := first_frame (enum_code) /= Default_frame
		end

	has_user_text (a_description: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := User_text_table.has (Current, a_description)
		end

feature -- Element change

	set_album (a_album: READABLE_STRING_GENERAL)
		do
			set_frame_text (Frame_id.TALB, a_album)
		ensure then
			set: album.same_string (a_album)
		end

	set_album_artist (a_album_artist: READABLE_STRING_GENERAL)
		do
			set_frame_text (Frame_id.TPE2, a_album_artist)
		ensure then
			set: album_artist.same_string (a_album_artist)
		end

	set_artist (a_artist: READABLE_STRING_GENERAL)
		do
			set_frame_text (Frame_id.TPE1, a_artist)
		end

	set_comment (description, text: READABLE_STRING_GENERAL)
		local
			frame: TL_COMMENTS_ID3_FRAME
		do
			if Comments_table.has_key (Current, description) then
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
			set: composer.same_string (a_composer)
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

	set_title (a_title: READABLE_STRING_GENERAL)
		do
			set_frame_text (Frame_id.TIT2, a_title)
		ensure then
			set: title.same_string (a_title)
		end

	set_unique_id (owner: READABLE_STRING_GENERAL; identifier: STRING)
		local
			ufid: TL_UNIQUE_FILE_IDENTIFIER_ID3_FRAME
		do
			if Unique_file_identifier_table.has_key (Current, owner) then
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
			if User_text_table.has_key (Current, a_description) then
				User_text_table.found_item.set_text (a_text)
			else
				create frame.make (a_description, a_text.split ('%N'), text_encoding)
				add_frame (frame)
			end
		ensure then
			set: a_text.same_string (user_text (a_description))
		end

feature -- Removal

	remove_frame (frame: TL_ID3_TAG_FRAME)
		do
			cpp_remove_frame (self_ptr, frame.self_ptr)
		end

	remove_unique_id (owner: READABLE_STRING_GENERAL)
		do
			if Unique_file_identifier_table.has_key (Current, owner) then
				remove_frame (Unique_file_identifier_table.found_item)
			end
		end

	remove_user_text (a_description: READABLE_STRING_GENERAL)
		do
			if User_text_table.has_key (Current, a_description) then
				remove_frame (User_text_table.found_item)
			end
		end

feature -- Constants

	Type: INTEGER = 2

	Version: INTEGER = 2
		-- ID3 version number

feature {NONE} -- Implementation

	add_frame (frame: TL_ID3_TAG_FRAME)
		do
			cpp_add_frame (self_ptr, frame.self_ptr)
		end

	filled_once_string (enum_code: NATURAL_8): like Once_string
		local
			id: like Once_byte_vector
		do
			Result := Once_string
			id := Once_byte_vector; id.set_from_frame_id (enum_code)
			cpp_get_first_frame_text (self_ptr, id.self_ptr, Result.self_ptr)
		end

	first_frame (enum_code: NATURAL_8): TL_ID3_TAG_FRAME
		require
			valid_code: valid_frame_id (enum_code)
		local
			cursor: TL_ID3_FRAME_ITERATION_CURSOR
		do
			cursor := frame_list (enum_code).new_cursor
			if cursor.after then
				Result := Default_frame
			else
				Result := cursor.item
			end
		end

	frame_list (enum_code: NATURAL_8): TL_ID3_FRAME_LIST
		require
			valid_code: valid_frame_id (enum_code)
		local
			id: like Once_byte_vector
		do
			id := Once_byte_vector; id.set_from_frame_id (enum_code)
			Result := Once_frame_list
			Result.set_from_pointer (cpp_frame_list (self_ptr, id.self_ptr))
		end

	iterable_frame_codes: EL_CPP_STD_LIST [TL_ID3_FRAME_CODE_ITERATION_CURSOR, NATURAL_8]
		do
			create Result.make (agent cpp_frame_list_begin (self_ptr), agent cpp_frame_list_end (self_ptr))
		end

	iterable_frames: EL_CPP_STD_LIST [TL_ID3_FRAME_ITERATION_CURSOR, TL_ID3_TAG_FRAME]
		do
			create Result.make (agent cpp_frame_list_begin (self_ptr), agent cpp_frame_list_end (self_ptr))
		end

	set_frame_text (enum_code: NATURAL_8; text: READABLE_STRING_GENERAL)
		require
			valid_code: valid_frame_id (enum_code)
		local
			frame: TL_TEXT_IDENTIFICATION_ID3_FRAME
		do
			if attached {TL_TEXT_IDENTIFICATION_ID3_FRAME} first_frame (enum_code) as l_frame then
				l_frame.set_text (text)
			else
				create frame.make (enum_code, text_encoding)
				frame.set_text (text)
				add_frame (frame)
			end
		ensure
			set: frame_text (enum_code).same_string (text)
		end

	shared_user_text_list (a_description: READABLE_STRING_GENERAL): like Once_user_text_list
		-- shared user text list `Once_user_text_list'
		do
			Result := Once_user_text_list
			Result.wipe_out
			if User_text_table.has_key (Current, a_description) then
				User_text_table.found_item.fill (Result)
			end
		end

feature {NONE} -- Internal attributes

	text_encoding: NATURAL_8
		-- the text encoding to be used when creating new frames

	language: STRING
		-- language for comments

feature {NONE} -- Constants

	Basic_text_frame_id_array: ARRAY [NATURAL_8]
		once
			Result := << Frame_id.TIT2, Frame_id.TALB, Frame_id.TPE1 >>
		end

	Once_frame_list: TL_ID3_FRAME_LIST
		once
			create Result.make
		end

	Once_user_text_list: EL_ZSTRING_LIST
		once
			create Result.make_empty
		end

	Comments_table: TL_COMMENTS_FRAME_TABLE
		once
			create Result
		end

	Default_language: STRING = "eng"

	Language_set: EL_HASH_SET [STRING]
		once
			create Result.make_equal (5)
			Result.put (Default_language)
		end

	Unique_file_identifier_table: TL_UNIQUE_FILE_IDENTIFIER_FRAME_TABLE
		once
			create Result
		end

	User_text_table: TL_USER_TEXT_FRAME_TABLE
		once
			create Result
		end

end
