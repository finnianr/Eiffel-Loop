note
	description: "Summary description for {EL_UNDERBIT_STRING_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_UNDERBIT_STRING_ROUTINES

inherit
	EL_MEMORY
		export
			{NONE} all
			{ANY} is_attached
		end

feature {NONE} -- Implementation

	genre_string (index: INTEGER): STRING
			--
		local
			ucs4_ptr: POINTER
			latin1: EL_C_STRING_8
		do
			ucs4_ptr := c_id3_genre_index (index)
			if is_attached (ucs4_ptr) then
				create latin1.make_owned (c_id3_ucs4_latin1duplicate (ucs4_ptr))
				Result := latin1.as_string_8
			else
				create Result.make_empty
			end
		end

feature {NONE} -- C externals: TO UCS4

	c_id3_latin1_ucs4duplicate (str_ptr: POINTER): POINTER
            -- id3_ucs4_t *id3_latin1_ucs4duplicate(id3_latin1_t const *)
        require
        	pointer_not_null: is_attached (str_ptr)
        external
            "C (id3_latin1_t const *): EIF_POINTER | %"id3tag.h%""
        alias
        	"id3_latin1_ucs4duplicate"
        end

    c_id3_utf8_ucs4duplicate (utf8_ptr: POINTER): POINTER
            -- id3_ucs4_t *id3_utf8_ucs4duplicate(id3_utf8_t const *);
        require
        	pointer_not_null: is_attached (utf8_ptr)
        external
            "C (id3_utf8_t const *): EIF_POINTER | %"id3tag.h%""
        alias
        	"id3_utf8_ucs4duplicate"
        end

    c_id3_utf16_ucs4duplicate (utf16_ptr: POINTER): POINTER
            -- id3_ucs4_t *id3_utf16_ucs4duplicate(id3_utf16_t const *);
        require
        	pointer_not_null: is_attached (utf16_ptr)
        external
            "C (id3_utf16_t const *): EIF_POINTER | %"id3tag.h%""
        alias
        	"id3_utf16_ucs4duplicate"
        end

feature {NONE} -- C externals: FROM UCS4

    c_id3_ucs4_latin1duplicate (ucs4_ptr: POINTER): POINTER
            -- id3_latin1_t *id3_ucs4_latin1duplicate(id3_ucs4_t const *);
        require
        	pointer_not_null: is_attached (ucs4_ptr)
        external
            "C (id3_ucs4_t const *): EIF_POINTER | %"id3tag.h%""
        alias
        	"id3_ucs4_latin1duplicate"
        end

    c_id3_ucs4_utf8duplicate (ucs4_ptr: POINTER): POINTER
            -- id3_utf8_t *id3_ucs4_utf8duplicate(id3_ucs4_t const *);
        require
        	pointer_not_null: is_attached (ucs4_ptr)
        external
            "C (id3_ucs4_t const *): EIF_POINTER | %"id3tag.h%""
        alias
        	"id3_ucs4_utf8duplicate"
        end

    c_id3_ucs4_utf16duplicate (ucs4_ptr: POINTER): POINTER
            -- id3_utf16_t *id3_ucs4_utf16duplicate(id3_ucs4_t const *);
        require
        	pointer_not_null: is_attached (ucs4_ptr)
        external
            "C (id3_ucs4_t const *): EIF_POINTER | %"id3tag.h%""
        alias
        	"id3_ucs4_utf16duplicate"
        end

    c_id3_ucs4_duplicate (ucs4_ptr: POINTER): POINTER
            -- id3_ucs4_t *id3_ucs4_duplicate(id3_ucs4_t const *)
        require
        	pointer_not_null: is_attached (ucs4_ptr)
        external
            "C (id3_ucs4_t const *): EIF_POINTER | %"id3tag.h%""
        alias
        	"id3_ucs4_duplicate"
        end

feature {NONE} -- C externals

    c_id3_ucs4_getnumber (ucs4_ptr: POINTER): INTEGER
            -- unsigned long id3_ucs4_getnumber(id3_ucs4_t const *);
        require
        	pointer_not_null: is_attached (ucs4_ptr)
        external
            "C (id3_ucs4_t const *): EIF_INTEGER | %"id3tag.h%""
        alias
        	"id3_ucs4_getnumber"
        end

    c_id3_ucs4_size (ucs4_ptr: POINTER): INTEGER
            -- id3_length_t id3_ucs4_size(id3_ucs4_t const *ucs4)
        require
        	pointer_not_null: is_attached (ucs4_ptr)
        external
            "C (id3_ucs4_t const *): EIF_INTEGER | %"id3tag.h%""
        alias
        	"id3_ucs4_size"
        end

    c_id3_genre_index (index: INTEGER): POINTER
            -- id3_ucs4_t const *id3_genre_index(unsigned int)
        external
            "C (unsigned int): EIF_POINTER | %"id3tag.h%""
        alias
        	"id3_genre_index"
        end

end
