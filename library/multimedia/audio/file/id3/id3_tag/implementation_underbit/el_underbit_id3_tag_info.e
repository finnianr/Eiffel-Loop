note
	description: "[
		Wrapper for ID3 tag editing library libid3tag from Underbit Technologies
		Reads ID3 version <= 2.3
		Writes ID3 version 2.4
		Unable to read version number
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 13:47:56 GMT (Wednesday 16th December 2015)"
	revision: "7"

class
	EL_UNDERBIT_ID3_TAG_INFO

inherit
	EL_ID3_INFO_I
		rename
			cpp_delete as c_id3_file_close
		undefine
			c_id3_file_close
		redefine
			is_memory_owned
		end

	EL_UNDERBIT_ID3_TAG_CONSTANTS
		export
			{NONE} all
		undefine
			default_create
		end

	EL_MODULE_LOG
		undefine
			default_create
		end

create
    make

feature -- Initialization

    make
		    --
      do
			default_create
		end

feature -- File writes

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
			options := c_id3_tag_options (frames_ptr, Tag_option_id3v1, (0).bit_not)
			update
		end

	update_v2
			--
		local
			options: INTEGER
		do
			options := c_id3_tag_options (frames_ptr, Tag_option_id3v1, 0)
			update
		end

	strip_v1, strip_v2
			--
		do
		end

feature {NONE} -- Removal

	detach (field: like new_field)
			--
		do
			c_call_status := c_id3_tag_detachframe (frames_ptr, field.self_ptr)
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

	set_version (a_version: REAL)
			--
		do
		end

	link_and_read (a_mp3_path: like mp3_path)
		do
			mp3_path := a_mp3_path
			wipe_out
			make_from_pointer (file_c_pointer (File_mode_read_and_write))
			frames_ptr := c_id3_file_tag (self_ptr)
			frame_list := new_frame_list
		end

	link (a_mp3_path: like mp3_path)
		-- link file without reading tags
		do
			mp3_path := a_mp3_path
		end

feature {NONE} -- Factory

	new_field (an_id: STRING): EL_UNDERBIT_ID3_FRAME
			--
		do
			create Result.make_with_code (an_id)
			attach (Result)
		end

	new_unique_file_id_field (owner_id: ZSTRING; an_id: STRING): EL_UNDERBIT_ID3_UNIQUE_FILE_ID
			--
		do
			create Result.make (owner_id, an_id)
			attach (Result)
		end

	new_album_picture_frame (a_picture: EL_ID3_ALBUM_PICTURE): EL_ALBUM_PICTURE_UNDERBIT_ID3_FRAME
		do
			create Result.make (a_picture)
			attach (Result)
		end

	new_frame (index: INTEGER): EL_UNDERBIT_ID3_FRAME
		local
			frame_ptr: POINTER
		do
			frame_ptr := c_frame (frames_ptr, index - 1)
			create Result.make_from_pointer (frame_ptr)
			if Result.code ~ Tag.Unique_file_id then
				create {EL_UNDERBIT_ID3_UNIQUE_FILE_ID} Result.make_from_pointer (frame_ptr)

			elseif Result.code ~ Tag.Album_picture then
				create {EL_ALBUM_PICTURE_UNDERBIT_ID3_FRAME} Result.make_from_pointer (frame_ptr)

			end
		end

	new_frame_list: ARRAYED_LIST [EL_UNDERBIT_ID3_FRAME]
		local
   		i, count: INTEGER
		do
			count := frame_count
			create Result.make (count)
			from i := 1 until i > count loop
				Result.extend (new_frame (i))
				i := i + 1
			end
		end

feature {NONE} -- Implementation

   frame_count: INTEGER
 		--
		do
			Result := c_frame_count (frames_ptr)
		end

	attach (field: like new_field)
			--
		do
			c_call_status := c_id3_tag_attachframe (frames_ptr, field.self_ptr)
			frame_list.extend (field)
		ensure
			is_attached: c_call_status = 0
		end

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

	is_memory_owned: BOOLEAN = True

 	frames_ptr: POINTER

	c_call_status: INTEGER

feature {NONE} -- C Externals: file

    c_id3_file_open (file_name_ptr: POINTER; a_file_mode: INTEGER): POINTER
		    -- struct id3_file *id3_file_open(char const *, enum id3_file_mode);
		external
			"C (char const *, enum id3_file_mode): EIF_POINTER | %"id3tag.h%""
		alias
			"id3_file_open"
		end

    c_id3_file_close (a_file_ptr: POINTER)
		    -- int id3_file_close(struct id3_file *);
		require else
			pointer_not_null: is_attached (a_file_ptr)
		external
		    "C (struct id3_file *) | %"id3tag.h%""
		alias
			"id3_file_close"
		end

    c_id3_file_update (a_file_ptr: POINTER): INTEGER
		    -- int id3_file_update(struct id3_file *)
		require
    		pointer_not_null: is_attached (a_file_ptr)
		external
		    "C (struct id3_file *): EIF_INTEGER | %"id3tag.h%""
		alias
    	"id3_file_update"
		end

    c_id3_file_tag (a_file_ptr: POINTER): POINTER
		    -- struct id3_tag *id3_file_tag(struct id3_file const *);
		require
			pointer_not_null: is_attached (a_file_ptr)
		external
		    "C (struct id3_file const *): EIF_POINTER | %"id3tag.h%""
		alias
			"id3_file_tag"
		end

feature {NONE} -- C Externals: tag

	c_id3_tag_addref (tag_ptr: POINTER)
		    -- void id3_tag_addref(struct id3_tag *tag)
		require
			pointer_not_null: is_attached (tag_ptr)
		external
		    "C (struct id3_tag const *) | %"id3tag.h%""
		alias
			"id3_tag_addref"
		end

     c_id3_tag_delref (tag_ptr: POINTER)
		    -- void id3_tag_delref(struct id3_tag *tag)
		require
			pointer_not_null: is_attached (tag_ptr)
		external
		   "C (struct id3_tag const *) | %"id3tag.h%""
		alias
			"id3_tag_delref"
		end

    c_id3_tag_delete (tag_ptr: POINTER)
		    -- void id3_tag_delete(struct id3_tag *);
		require
    		pointer_not_null: is_attached (tag_ptr)
		external
		    "C (struct id3_tag *)| %"id3tag.h%""
		alias
			"id3_tag_delete"
		end

    c_id3_tag_clear_frames (tag_ptr: POINTER)
		    -- void id3_tag_clearframes(struct id3_tag *);
		require
			pointer_not_null: is_attached (tag_ptr)
		external
		    "C (struct id3_tag *)| %"id3tag.h%""
		alias
			"id3_tag_clearframes"
		end


    c_id3_tag_findframe (tag_ptr, frame_id: POINTER; c: INTEGER): POINTER
		    --struct id3_frame *id3_tag_findframe(struct id3_tag const *, char const *, unsigned int);
      require
			pointer_not_null: is_attached (tag_ptr)
      external
		    "C (struct id3_tag const *, char const *, unsigned int): EIF_POINTER | %"id3tag.h%""
		alias
			"id3_tag_findframe"
		end

    c_id3_tag_attachframe (tag_ptr, frame_ptr: POINTER): INTEGER
		    -- int id3_tag_attachframe(struct id3_tag *, struct id3_frame *);
      require
    		pointer_not_null: is_attached (tag_ptr) and is_attached (frame_ptr)
      external
		    "C (struct id3_tag const *, struct id3_frame *): EIF_INTEGER | %"id3tag.h%""
		alias
    		"id3_tag_attachframe"
		end

    c_id3_tag_detachframe (tag_ptr, frame_ptr: POINTER): INTEGER
		    -- int id3_tag_detachframe(struct id3_tag *, struct id3_frame *);
		require
		pointer_not_null: is_attached (tag_ptr) and is_attached (frame_ptr)
		external
		    "C (struct id3_tag const *, struct id3_frame *): EIF_INTEGER | %"id3tag.h%""
		alias
    	"id3_tag_detachframe"
		end

    c_id3_tag_version (tag_ptr: POINTER): INTEGER
		    -- unsigned int id3_tag_version(struct id3_tag const *)
		require
    		pointer_not_null: is_attached (tag_ptr)
		external
		    "C (struct id3_tag const *): EIF_INTEGER | %"id3tag.h%""
		alias
    	"id3_tag_version"
		end

    c_id3_set_tag_version (tag_ptr: POINTER; ver: INTEGER)
		    -- unsigned int id3_tag_version(struct id3_tag const *)
		require
    		pointer_not_null: is_attached (tag_ptr)
		external
		    "C [struct %"id3tag.h%"] (struct id3_tag, unsigned int)"
		alias
    		"version"
		end

     c_frame_count (tag_ptr: POINTER): INTEGER
		    -- Access field y of struct pointed by `p'.
		require
    		pointer_not_null: is_attached (tag_ptr)
		external
		    "C [struct %"id3tag.h%"] (struct id3_tag): EIF_INTEGER"
		alias
		    "nframes"
		end

     c_frame (tag_ptr: POINTER; i: INTEGER): POINTER
		    -- Access field y of struct pointed by `p'.
		require
    		pointer_not_null: is_attached (tag_ptr)
		external
		    "C inline use %"id3tag.h%""
		alias
		    "((struct id3_tag*)$tag_ptr)->frames[$i]"
		end

    c_id3_tag_options (tag_ptr: POINTER; mask, values: INTEGER): INTEGER
		    -- int id3_tag_options(struct id3_tag *, int, int)
		require
    		pointer_not_null: is_attached (tag_ptr)
		external
		    "C (struct id3_tag const *, int, int): EIF_INTEGER | %"id3tag.h%""
		alias
    		"id3_tag_options"
		end

     c_id3_tag_version_major (a_version: INTEGER): INTEGER
		    -- Access field y of struct pointed by `p'.
		require
    	version_not_zero: a_version > 0
		external
		    "C [macro %"id3tag.h%"] (unsigned int): EIF_INTEGER"
		alias
		    "ID3_TAG_VERSION_MAJOR"
		end

     c_id3_tag_version_minor (a_version: INTEGER): INTEGER
		    -- Access field y of struct pointed by `p'.
		require
    		version_not_zero: a_version > 0
		external
		    "C [macro %"id3tag.h%"] (unsigned int): EIF_INTEGER"
		alias
		    "ID3_TAG_VERSION_MINOR"
		end

end
