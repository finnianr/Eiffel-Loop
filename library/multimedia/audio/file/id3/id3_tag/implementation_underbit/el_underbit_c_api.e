note
	description: "Summary description for {EL_UNDERBIT_C_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_UNDERBIT_C_API

inherit
	EL_MEMORY
		export
			{NONE} all
			{ANY} is_attached
		end

feature {NONE} -- Frames

     c_id3_frame_field (frame_ptr: POINTER; index: INTEGER): POINTER
            -- union id3_field *id3_frame_field(struct id3_frame const *, unsigned int);
        require
        	argument_attached: is_attached (frame_ptr)
        external
            "C (struct id3_frame const *, unsigned int): EIF_POINTER | %"id3tag.h%""
        alias
        	"id3_frame_field"
        end

    c_id3_frame_new (id_ptr: POINTER): POINTER
            -- struct id3_frame *id3_frame_new(char const *);
        require
        	argument_attached: is_attached (id_ptr)
        external
            "C (char const *): EIF_POINTER | %"id3tag.h%""
        alias
        	"id3_frame_new"
        end

     c_id3_frame_addref (frame_ptr: POINTER)
            -- void id3_frame_addref(struct id3_frame *frame)
        require
        	argument_attached: is_attached (frame_ptr)
        external
            "C (struct id3_frame const *) | %"id3tag.h%""
        alias
        	"id3_frame_addref"
        end

     c_id3_frame_delref (frame_ptr: POINTER)
            -- void id3_frame_delref(struct id3_frame *frame)
        require
        	argument_attached: is_attached (frame_ptr)
        external
            "C (struct id3_frame const *) | %"id3tag.h%""
        alias
        	"id3_frame_delref"
        end

    c_id3_frame_delete (frame_ptr: POINTER)
            -- void id3_frame_delete(struct id3_frame *frame)
        require
        	argument_attached: is_attached (frame_ptr)
        external
            "C (struct id3_frame const *) | %"id3tag.h%""
        alias
        	"id3_frame_delete"
        end

     c_id3_frame_id (frame_ptr: POINTER): POINTER
            -- Access field y of struct pointed by `p'.
        require
        	argument_attached: is_attached (frame_ptr)
        external
            "C [struct %"id3tag.h%"] (struct id3_frame): EIF_POINTER"
        alias
            "id"
        end

     c_id3_frame_nfields (frame_ptr: POINTER): INTEGER
            -- Access field y of struct pointed by `p'.
        require
        	argument_attached: is_attached (frame_ptr)
        external
            "C [struct %"id3tag.h%"] (struct id3_frame): EIF_POINTER"
        alias
            "nfields"
        end

feature {NONE} -- Field getters

	c_id3_field_getstrings (field_ptr: POINTER; index: INTEGER): POINTER
            -- id3_ucs4_t const *id3_field_getstrings(union id3_field const *field, unsigned int index)
        require
        	argument_attached: is_attached (field_ptr)
        external
            "C (union id3_field const *, unsigned int): EIF_POINTER | %"id3tag.h%""
        alias
        	"id3_field_getstrings"
        end

	c_id3_field_getstring (field_ptr: POINTER): POINTER
            -- id3_ucs4_t const *id3_field_getstring(union id3_field const *field)
        require
        	argument_attached: is_attached (field_ptr)
        external
            "C (union id3_field const *): EIF_POINTER | %"id3tag.h%""
        alias
        	"id3_field_getstring"
        end

	c_id3_field_getfullstring (field_ptr: POINTER): POINTER
            -- id3_ucs4_t const *id3_field_getfullstring(union id3_field const *field)
        require
        	argument_attached: is_attached (field_ptr)
        external
            "C (union id3_field const *): EIF_POINTER | %"id3tag.h%""
        alias
        	"id3_field_getfullstring"
        end

	c_id3_field_getlatin1 (field_ptr: POINTER): POINTER
            -- id3_latin1_t const *id3_field_getlatin1(union id3_field const *field)
        require
        	argument_attached: is_attached (field_ptr)
        external
            "C (union id3_field const *): EIF_POINTER | %"id3tag.h%""
        alias
        	"id3_field_getlatin1"
        end

	c_id3_field_getfulllatin1 (field_ptr: POINTER): POINTER
            -- id3_latin1_t const *id3_field_getlatin1(union id3_field const *field)
        require
        	argument_attached: is_attached (field_ptr)
        external
            "C (union id3_field const *): EIF_POINTER | %"id3tag.h%""
        alias
        	"id3_field_getfulllatin1"
        end

	c_id3_field_getbinarydata (field_ptr, length_ptr: POINTER): POINTER
            -- id3_byte_t const *id3_field_getbinarydata(union id3_field const *field, id3_length_t *length)

        require
        	argument_attached: is_attached (field_ptr)
        external
            "C (union id3_field const *, id3_length_t *): EIF_POINTER | %"id3tag.h%""
        alias
        	"id3_field_getbinarydata"
        end

     c_id3_field_getint (field_ptr: POINTER): INTEGER
            -- signed long id3_field_getint(union id3_field const *);
        require
        	argument_attached: is_attached (field_ptr)
        external
            "C (union id3_field const *): EIF_INTEGER | %"id3tag.h%""
        alias
        	"id3_field_getint"
        end

     c_id3_field_gettextencoding (field_ptr: POINTER): INTEGER
            -- enum id3_field_textencoding id3_field_gettextencoding(union id3_field const *);
        require
        	argument_attached: is_attached (field_ptr)
        external
            "C (union id3_field const *): EIF_INTEGER | %"id3tag.h%""
        alias
        	"id3_field_gettextencoding"
        end

     c_id3_field_type (field_ptr: POINTER): INTEGER
            -- enum id3_field_type id3_field_type(union id3_field const *);
        require
        	argument_attached: is_attached (field_ptr)
        external
            "C (union id3_field const *): EIF_INTEGER | %"id3tag.h%""
        alias
        	"id3_field_type"
        end

     c_id3_field_getnstrings (field_ptr: POINTER): INTEGER
            -- unsigned int id3_field_getnstrings(union id3_field const *field)
        require
        	argument_attached: is_attached (field_ptr)
        external
            "C (union id3_field const *): EIF_INTEGER | %"id3tag.h%""
        alias
        	"id3_field_getnstrings"
        end

	c_id3_field_value (field_ptr: POINTER): POINTER
        external
            "C inline use %"id3tag.h%""
        alias
            "((union id3_field*)$field_ptr)->immediate.value"
        end

feature {NONE} -- Field setters

	c_id3_field_setstrings (field_ptr: POINTER; count: INTEGER; str_ptr_array_ptr: POINTER): INTEGER
            -- int id3_field_setstrings(union id3_field *, unsigned int, id3_ucs4_t **);
        require
        	argument_attached: is_attached (field_ptr) and is_attached (str_ptr_array_ptr)
        external
            "C (union id3_field const *, unsigned int, id3_ucs4_t **): EIF_INTEGER | %"id3tag.h%""
        alias
        	"id3_field_setstrings"
        end

	c_id3_field_setlatin1 (field_ptr: POINTER; str_ptr: POINTER): INTEGER
            -- int id3_field_setlatin1(union id3_field *, id3_latin1_t const *);
        require
        	argument_attached: is_attached (field_ptr) and is_attached (str_ptr)
        external
            "C (union id3_field const *, id3_latin1_t const *): EIF_INTEGER | %"id3tag.h%""
        alias
        	"id3_field_setlatin1"
        end

	c_id3_field_setfulllatin1 (field_ptr: POINTER; str_ptr: POINTER): INTEGER
            -- int id3_field_setlatin1(union id3_field *, id3_latin1_t const *);
        require
        	argument_attached: is_attached (field_ptr) and is_attached (str_ptr)
        external
            "C (union id3_field const *, id3_latin1_t const *): EIF_INTEGER | %"id3tag.h%""
        alias
        	"id3_field_setfulllatin1"
        end

	c_id3_field_setstring (field_ptr: POINTER; str_ptr: POINTER): INTEGER
            -- int id3_field_setstring(union id3_field *, id3_ucs4_t const *);
        require
        	argument_attached: is_attached (field_ptr) and is_attached (str_ptr)
        external
            "C (union id3_field const *, id3_ucs4_t const *): EIF_INTEGER | %"id3tag.h%""
        alias
        	"id3_field_setstring"
        end

	c_id3_field_setfullstring (field_ptr: POINTER; str_ptr: POINTER): INTEGER
            -- int id3_field_setstring(union id3_field *, id3_ucs4_t const *);
        require
        	argument_attached: is_attached (field_ptr) and is_attached (str_ptr)
        external
            "C (union id3_field const *, id3_ucs4_t const *): EIF_INTEGER | %"id3tag.h%""
        alias
        	"id3_field_setfullstring"
        end

	c_id3_field_setbinarydata (field_ptr, data_ptr: POINTER; length: INTEGER): INTEGER
            -- int id3_field_setbinarydata(union id3_field *, id3_byte_t const *, id3_length_t);

        require
        	argument_attached: is_attached (field_ptr) and is_attached (data_ptr)
        external
            "C (union id3_field const *, id3_byte_t const *, id3_length_t): EIF_INTEGER | %"id3tag.h%""
        alias
        	"id3_field_setbinarydata"
        end

	c_id3_field_settextencoding (field_ptr: POINTER; code: INTEGER): INTEGER
            -- int id3_field_settextencoding(union id3_field *, enum id3_field_textencoding)

        require
        	argument_attached: is_attached (field_ptr)
        external
            "C (union id3_field *, enum id3_field_textencoding): EIF_INTEGER | %"id3tag.h%""
        alias
        	"id3_field_settextencoding"
        end

feature {NONE} -- Field create/destroy

	c_id3_field_finish (field_ptr: POINTER)
            -- void id3_field_finish(union id3_field *field)

        require
        	argument_attached: is_attached (field_ptr)
        external
            "C (union id3_field *) | %"field.h%""
        alias
        	"id3_field_finish"
        end

	c_id3_field_init (field_ptr: POINTER; a_type: INTEGER)
            -- void id3_field_init(union id3_field *field, enum id3_field_type type)

        require
        	argument_attached: is_attached (field_ptr)
        external
            "C (union id3_field *, enum id3_field_type) | %"field.h%""
        alias
        	"id3_field_init"
        end

end
