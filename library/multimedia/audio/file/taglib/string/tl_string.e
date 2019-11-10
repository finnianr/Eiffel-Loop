note
	description: "Wrapper for `TagLib::String' class defined in `toolkit/tstring.h'"
	notes: "[
		Internally the strings are represented as UTF-16 code sequences
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-10 19:06:24 GMT (Sunday 10th November 2019)"
	revision: "5"

class
	TL_STRING

inherit
	EL_OWNED_CPP_OBJECT

	TL_STRING_CPP_API

	EL_SHARED_ONCE_STRING_32

create
	make, make_empty

feature {NONE} -- Initialization

	make_empty
		do
			make (cpp_new)
		end

	make (a_ptr: POINTER)
		--
		do
			if is_attached (a_ptr) then
				make_from_pointer (a_ptr)
				count := cpp_size (self_ptr)
			end
		end

feature -- Status query

	equals (str: STRING): BOOLEAN
		local
			to_c: ANY
		do
			to_c := str.to_c
			Result := cpp_equals (self_ptr, $to_c)
		end

	is_empty: BOOLEAN
		do
			Result := count = 0
		end

	is_latin_1: BOOLEAN
		do
			if is_attached (self_ptr) then
				Result := cpp_is_latin_1 (self_ptr)
			end
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

	to_string_8, to_latin_1: STRING_8
		require
			latin_1_encoded: is_latin_1
		local
			i: INTEGER
		do
			create Result.make (count)
			from i := 1 until i > count loop
				Result.extend (i_th_code (i).to_character_8)
				i := i + 1
			end
		end

feature -- Element change

	set_from_string (str: ZSTRING)
		do
			Setter.set_string (Current, str)
		end

	set_from_string_8 (str: STRING)
		do
			Setter.set_string_8 (Current, str)
		end

	set_from_string_32 (str: STRING_32)
		do
			Setter.set_string_32 (Current, str)
		end

	wipe_out
		do
			cpp_clear (self_ptr)
		end

feature {TL_STRING_SETTER_I} -- Element change

	set_from_utf_16 (utf_16: POINTER)
		do
			wipe_out
			cpp_append (self_ptr, utf_16)
		end

feature {NONE} -- Implementation

	i_th_code (index: INTEGER): NATURAL
		require
			self_attached: is_attached (self_ptr)
			valid_index: 1 <= index and index <= count
		do
			Result := cpp_i_th (self_ptr, index - 1)
		end

feature {NONE} -- Internal attributes

	Setter: TL_STRING_SETTER_I
		once
			create {TL_STRING_SETTER_IMP} Result
		end

end
