note
	description: "Summary description for {EL_UNDERBIT_ID3_ENCODED_FIELD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "5"

class
	EL_UNDERBIT_ID3_ENCODED_FIELD

inherit
	EL_UNDERBIT_ID3_FIELD
		rename
			make as make_field
		redefine
			set_encoding, encoding
		end

create
	make
	
feature -- Initialization

	make (obj_ptr: POINTER; a_encoding_field: EL_UNDERBIT_ID3_ENCODING_FIELD)
			--
		require
			valid_object: is_attached (obj_ptr)
		do
			make_field (obj_ptr)
			encoding_field := a_encoding_field
		end

feature -- Access

	encoding: INTEGER
			--
		do
			Result := encoding_field.encoding
		end

feature -- Element change

	set_encoding (new_encoding: INTEGER)
			--
		local
			ucs4_duplicate, latin1_duplicate: POINTER
			l_type, new_type: INTEGER
		do
			l_type := field_type
			if encoding_field.encoding /= new_encoding then
				new_type := l_type
				if l_type = Field_type_latin1 then
					if new_encoding /= Encoding_ISO_8859_1 then
						ucs4_duplicate := c_id3_latin1_ucs4duplicate (c_id3_field_getlatin1 (self_ptr))
						new_type := Field_type_string
					end

				elseif l_type = field_type_full_latin1 then
					if new_encoding /= Encoding_ISO_8859_1 then
						ucs4_duplicate := c_id3_latin1_ucs4duplicate (c_id3_field_getfulllatin1 (self_ptr))
						new_type := Field_type_full_string
					end

				elseif l_type = Field_type_string then
					if new_encoding = Encoding_ISO_8859_1 then
						ucs4_duplicate := c_id3_ucs4_duplicate (c_id3_field_getstring (self_ptr))
						new_type := Field_type_latin1
					end

				elseif l_type = Field_type_full_string then
					if new_encoding = Encoding_ISO_8859_1 then
						ucs4_duplicate := c_id3_ucs4_duplicate (c_id3_field_getfullstring (self_ptr))
						new_type := field_type_full_latin1
					end

				elseif l_type = Field_type_list_string and string_count > 0 then
					if new_encoding = Encoding_ISO_8859_1 then
						ucs4_duplicate := c_id3_ucs4_duplicate (c_id3_field_getstrings (self_ptr, 0))
						new_type := Field_type_latin1
					end
				end
				if new_type /= l_type then
					c_id3_field_finish (self_ptr)
					c_id3_field_init (self_ptr, new_type)

					if new_type = Field_type_latin1 then
						latin1_duplicate := c_id3_ucs4_latin1duplicate (ucs4_duplicate)
						c_call_status := c_id3_field_setlatin1 (self_ptr, latin1_duplicate)
						latin1_duplicate.memory_free

					elseif new_type = field_type_full_latin1 then
						latin1_duplicate := c_id3_ucs4_latin1duplicate (ucs4_duplicate)
						c_call_status := c_id3_field_setfulllatin1 (self_ptr, latin1_duplicate)
						latin1_duplicate.memory_free

					elseif new_type = Field_type_string then
						c_call_status := c_id3_field_setstring (self_ptr, ucs4_duplicate)

					elseif new_type = Field_type_full_string then
						c_call_status := c_id3_field_setfullstring (self_ptr, ucs4_duplicate)

					end
					ucs4_duplicate.memory_free
					check
						correct_type: l_type = new_type
					end
				end
			end
		ensure then
			c_call_succeeded: c_call_status = 0
		end

feature {NONE} -- Implementation

	encoding_field: EL_UNDERBIT_ID3_ENCODING_FIELD

end

