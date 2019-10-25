note
	description: "Libid3 latin 1 string field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-17 12:34:39 GMT (Thursday   17th   October   2019)"
	revision: "1"

class
	LIBID3_LATIN_1_STRING_FIELD

inherit
	ID3_LATIN_1_STRING_FIELD

	LIBID3_FRAME_FIELD
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make (a_ptr: POINTER)
			--
		require else
			is_latin_1: libid3_encoding = Encoding_ISO8859_1
		do
			Precursor (a_ptr)
		end

feature -- Access

	string: STRING
			--
		do
			create Result.make_from_string (shared_latin)
		end

feature -- Element change

	set_string (str: like string)
			--
		do
			bytes_read := cpp_set_text (self_ptr, str.area.base_address)
		ensure then
			is_set: bytes_read = str.count and str ~ string
		end

feature {NONE} -- Implementation

	libid3_encoding: INTEGER
			--
		do
			Result := cpp_encoding (self_ptr)
		end

	set_libid3_encoding (encoding: INTEGER)
		do
			c_call_succeeded := cpp_set_encoding (self_ptr, encoding)
		end

	text_size: INTEGER
			--
		do
			Result := cpp_size (self_ptr)
		end

	shared_latin: EL_STRING_8
		do
			Result := Utf_8; Result.wipe_out
			Result.from_c (cpp_text (self_ptr))
		end

feature {NONE} -- Internal attributes

	characters_copied, bytes_read: INTEGER

feature {NONE} -- Constant

	Libid3_types: ARRAY [INTEGER]
		once
			Result := << FN_email, FN_mime_type, FN_image_format, FN_owner, FN_url >>
		end

	Utf_8: EL_STRING_8
		once
			create Result.make_empty
		end

end
