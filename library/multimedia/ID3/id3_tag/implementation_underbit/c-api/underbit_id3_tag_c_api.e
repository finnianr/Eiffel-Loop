note
	description: "Underbit id3 tag c api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	UNDERBIT_ID3_TAG_C_API

inherit
	EL_C_API_ROUTINES
		export
			{NONE} all
		end

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