note
	description: "[
		Wrapper for ID3 tag editing library libid3tag from Underbit Technologies
		Reads ID3 version <= 2.3
		Writes ID3 version 2.4
		Unable to read version number
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-15 2:03:43 GMT (Tuesday   15th   October   2019)"
	revision: "3"

class
	UNDERBIT_ID3_TAG_INFO

inherit
	ID3_INFO_I

	EL_C_OBJECT
		rename
			c_free as c_id3_file_close
		undefine
			default_create, c_id3_file_close, is_memory_owned
		end

	UNDERBIT_ID3_CONSTANTS
		export
			{NONE} all
		undefine
			default_create
		end

	UNDERBIT_ID3_C_API undefine default_create, dispose end

	UNDERBIT_ID3_TAG_C_API undefine default_create, dispose end

	EL_FACTORY_CLIENT undefine default_create end

create
	make

feature -- Initialization

	make
			--
		do
			default_create
		end

feature -- File writes

	strip_v1, strip_v2
			--
		do
		end

	update
			--
		do
			c_call_status := c_id3_file_update (self_ptr)
		ensure then
			is_updated: c_call_status = 0
		end

	update_v1
			--
		local
			options: INTEGER
		do
			options := c_id3_tag_options (id3_file_tag, Tag_option_id3v1, (0).bit_not)
			update
		end

	update_v2
			--
		local
			options: INTEGER
		do
			options := c_id3_tag_options (id3_file_tag, Tag_option_id3v1, 0)
			update
		end

feature {NONE} -- Removal

	detach (field: like new_field)
			--
		do
			c_call_status := c_id3_tag_detachframe (id3_file_tag, field.self_ptr)
		ensure then
			is_removed: c_call_status = 0
		end

	wipe_out
			--
		do
			frame_list.wipe_out
			dispose
		end

feature -- Element change

	link (a_mp3_path: like mp3_path)
			-- link file without reading tags
		do
			mp3_path := a_mp3_path
		end

	link_and_read (a_mp3_path: like mp3_path)
		local
			utf_8_path: STRING; to_c: ANY
		do
			mp3_path := a_mp3_path
			wipe_out
			utf_8_path := mp3_path.to_string.to_utf_8
			to_c := utf_8_path.to_c
			make_from_pointer (c_id3_file_open ($to_c, File_mode_read_and_write))
			if is_attached (self_ptr) then
				frame_list := new_frame_list
			end
		end

	set_version (a_version: REAL)
			--
		do
		end

feature {NONE} -- Factory

	new_album_picture_frame (a_picture: ID3_ALBUM_PICTURE): UNDERBIT_ID3_ALBUM_PICTURE_FRAME
		do
			create Result.make (a_picture)
			attach (Result)
		end

	new_field (a_code: STRING): UNDERBIT_ID3_FRAME
			--
		do
			create Result.make_new (a_code)
			attach (Result)
		end

	new_frame (index: INTEGER): UNDERBIT_ID3_FRAME
		local
			frame_ptr: POINTER; code: ZSTRING
		do
			frame_ptr := c_frame (id3_file_tag, index - 1)
			create code.make_from_latin_1_c (c_id3_frame_id (frame_ptr))
			Result := Factory.instance_from_alias (code, agent {UNDERBIT_ID3_FRAME}.make (frame_ptr, code))
		end

	new_frame_list: EL_ARRAYED_LIST [UNDERBIT_ID3_FRAME]
		local
			i, count: INTEGER
		do
			count := frame_count
			create Result.make (count)
			from
				i := 1
			until
				i > count
			loop
				Result.extend (new_frame (i))
				i := i + 1
			end
		end

	new_unique_file_id_field (owner_id: ZSTRING; an_id: STRING): UNDERBIT_ID3_UNIQUE_FILE_ID_FRAME
			--
		do
			create Result.make (owner_id, an_id)
			attach (Result)
		end

feature {NONE} -- Implementation

	attach (field: like new_field)
			--
		do
			c_call_status := c_id3_tag_attachframe (id3_file_tag, field.self_ptr)
			frame_list.extend (field)
		ensure
			is_attached: c_call_status = 0
		end

	c_call_status: INTEGER

	file_c_pointer (file_mode: INTEGER): POINTER
			--
		require
			valid_mode: file_mode = File_mode_read_and_write or file_mode = File_mode_read_only
		local
			l_file_path: STRING
		do
			l_file_path := mp3_path.to_string.to_utf_8
			Result := c_id3_file_open (l_file_path.area.base_address, file_mode)
		ensure
			file_open: is_attached (Result)
		end

	frame_count: INTEGER
			--
		do
			Result := c_frame_count (id3_file_tag)
		end

	id3_file_tag: POINTER
		do
			Result := c_id3_file_tag (self_ptr)
		end

	is_memory_owned: BOOLEAN = True

feature {NONE} -- Constants

	Factory: EL_OBJECT_FACTORY [UNDERBIT_ID3_FRAME]
		once
			create Result.make_from_table (<<
				["default",				{UNDERBIT_ID3_FRAME}],
				[Tag.Unique_file_id,	{UNDERBIT_ID3_UNIQUE_FILE_ID_FRAME}],
				[Tag.Album_picture,	{UNDERBIT_ID3_ALBUM_PICTURE_FRAME}],
				[Tag.Genre,				{UNDERBIT_ID3_GENRE_FRAME}]
			>>)
		end

end
