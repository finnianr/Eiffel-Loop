note
	description: "Libid3 field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-05 9:45:48 GMT (Tuesday 5th January 2021)"
	revision: "9"

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

	EL_MODULE_UTF

	EL_SHARED_ONCE_STRING_32

create
	make

feature -- Access

	string: ZSTRING
			--
		do
			if encoding = Encoding_enum.ISO_8859_1 then
				create Result.make_from_general (shared_latin)

			elseif Encoding_enum.is_utf_16 (encoding) then
				Result := text_32 -- A bit strange that only Big Endian decoding works

			elseif encoding = Encoding_enum.UTF_8 then
				create Result.make_from_utf_8 (shared_latin)
			else
				create Result.make_empty
			end
		end

	count: INTEGER
		do
			Result := cpp_size (self_ptr)
		end

	self_encoding: NATURAL_8
			--
		do
			Result := Encoding_enum.from_libid3 (cpp_encoding (self_ptr))
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
			code: INTEGER
		do
			code := encoding
			if code = Encoding_enum.ISO_8859_1 then
				set_latin_1_string (str.to_latin_1)

			elseif code = Encoding_enum.UTF_16 or code = Encoding_enum.UTF_16_BE then
				-- A bit strange that only Big Endian works
				set_text_unicode (str.to_string_32)

			elseif code = Encoding_enum.UTF_8 then
				set_latin_1_string (str.to_utf_8)

			end
		end

feature {NONE} -- Implementation

	text_32: STRING_32
		local
			data: like Unicode_buffer
		do
			Result := once_empty_string_32
			data := Unicode_buffer
			data.set_from_pointer (cpp_unicode_text (self_ptr), count * 2 + 2)
			UTF.utf_16_be_0_pointer_into_string_32 (data, Result)
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
--			same_string: str ~ text_utf_16_be.as_string_32
		end

feature {NONE} -- Constant

	Unicode_buffer: MANAGED_POINTER
		once
			create Result.share_from_pointer (Default_pointer, 0)
		end

	Libid3_types: ARRAY [INTEGER]
		once
			Result := << FN_text, FN_filename >>
		end

end