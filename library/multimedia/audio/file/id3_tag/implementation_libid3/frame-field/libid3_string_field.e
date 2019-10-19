note
	description: "Libid3 field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-30 9:00:17 GMT (Tuesday 30th July 2019)"
	revision: "6"

class
	LIBID3_STRING_FIELD

inherit
	ID3_STRING_FIELD

	LIBID3_LATIN_1_STRING_FIELD
		rename
			make as make_from_pointer,
			string as latin_1_string,
			set_string as set_latin_1_string
		undefine
			type
		redefine
			Libid3_types
		end

create
	make

feature -- Access

	string: ZSTRING
			--
		local
			l_encoding: INTEGER
		do
			l_encoding := encoding
			if l_encoding = Encoding_enum.ISO_8859_1 then
				create Result.make_from_general (shared_latin)

			elseif l_encoding = Encoding_enum.UTF_16 or l_encoding = Encoding_enum.UTF_16_BE then
				-- A bit strange that only Big Endian decoding works
				Result := text_utf_16_be.as_string

			elseif l_encoding = Encoding_enum.UTF_8 then
				create Result.make_from_utf_8 (shared_latin)
			else
				create Result.make_empty

			end
		end

feature -- Element change

	set_encoding (a_new_encoding: NATURAL_8)
			--
		local
			is_changed: BOOLEAN
			l_string: like string
		do
			if encoding /= a_new_encoding then
				l_string := string
				is_changed := cpp_set_encoding (self_ptr, Encoding_enum.to_libid3 (a_new_encoding))
				if is_changed then
					set_string (l_string)
				end
			end
		end

	set_string (str: like string)
			--
		local
			l_encoding: INTEGER
		do
			l_encoding := encoding
			if l_encoding = Encoding_enum.ISO_8859_1 then
				set_latin_1_string (str.to_latin_1)

			elseif l_encoding = Encoding_enum.UTF_16 or l_encoding = Encoding_enum.UTF_16_BE then
				-- A bit strange that only Big Endian works
				set_text_unicode (str.to_string_32)

			elseif l_encoding = Encoding_enum.UTF_8 then
				set_latin_1_string (str.to_utf_8)

			end
		end

feature {NONE} -- Implementation

	text_utf_16_be: EL_C_STRING_16_BE
			--
		do
			create Result.make_shared (cpp_unicode_text (self_ptr))
		end

	set_text_unicode (str: STRING_32)
			--
		local
			c_string: EL_C_STRING_16_BE
		do
			create c_string.make_from_string (str)
			bytes_read := cpp_set_text_unicode (self_ptr, c_string.base_address)
		ensure
			unicode_field_correct_size: bytes_read // 2 = str.count
			same_string: str ~ text_utf_16_be.as_string_32
		end

feature {NONE} -- Constant

	Libid3_types: ARRAY [INTEGER]
		once
			Result := << FN_text, FN_filename >>
		end

end
