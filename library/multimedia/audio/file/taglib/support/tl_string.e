note
	description: "Tl string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-28 13:12:12 GMT (Monday   28th   October   2019)"
	revision: "2"

class
	TL_STRING

inherit
	EL_OWNED_CPP_OBJECT

	TL_STRING_CPP_API

	EL_SHARED_ONCE_STRING_32

create
	make

feature {NONE} -- Initialization

	make (a_ptr: POINTER)
		--
		do
			if is_attached (a_ptr) then
				make_from_pointer (a_ptr)
				count := cpp_size (self_ptr)
			end
		end

feature -- Status query

	is_latin_1: BOOLEAN
		do
			if is_attached (self_ptr) then
				Result := cpp_is_latin_1 (self_ptr)
			end
		end

	is_empty: BOOLEAN
		do
			Result := count = 0
		end

feature -- Measurement

	count: INTEGER

feature -- Conversion

	to_string: ZSTRING
		do
			Result := to_string_32 (False)
		end

	to_string_32 (keep_ref: BOOLEAN): STRING_32
		-- unicode string
		-- if `keep_ref' is `False', result is a shared instance
		local
			i: INTEGER; code: NATURAL
		do
			Result := empty_once_string_32
			from i := 1 until i > count loop
				code := i_th_code (i)
				i := i + 1
				if code < 0xD800 or code >= 0xE000 then
						-- Codepoint from Basic Multilingual Plane: one 16-bit code unit.
					Result.extend (code.to_character_32)
				elseif i <= count then
					Result.extend (((code.as_natural_32 |<< 10) + i_th_code (i) - 0x35FDC00).to_character_32)
					i := i + 1
				end
			end
			if keep_ref then
				Result := Result.twin
			end
		end

	to_string_8: STRING_8
		require
			latin_1_encoded: is_latin_1
		local
			i: INTEGER; code: NATURAL
		do
			create Result.make (count)
			from i := 1 until i > count loop
				Result.extend (i_th_code (i).to_character_8)
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	i_th_code (index: INTEGER): NATURAL
		require
			valid_index: 1 <= index and index <= count
		do
			Result := cpp_i_th (self_ptr, index - 1)
		end

end
