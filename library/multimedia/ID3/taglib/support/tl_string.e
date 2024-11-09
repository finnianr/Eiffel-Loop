note
	description: "Wrapper for `TagLib::String' class defined in `toolkit/tstring.h'"
	notes: "[
		Internally the strings are represented as UTF-16 code sequences
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-08 9:13:05 GMT (Friday 8th November 2024)"
	revision: "18"

class
	TL_STRING

inherit
	EL_OWNED_CPP_OBJECT
		rename
			make_from_pointer as make
		export
			{EL_CPP_API, TL_FRAME_TABLE} self_ptr
		end

	TL_STRING_CPP_API

	EL_SHARED_STRING_8_BUFFER_POOL; EL_SHARED_STRING_32_BUFFER_POOL

create
	make, make_empty

feature {NONE} -- Initialization

	make_empty
		do
			make (cpp_new)
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
			Result := cpp_is_latin_1 (self_ptr)
		end

feature -- Measurement

	count: INTEGER
		do
			Result := cpp_size (self_ptr)
		end

feature -- Conversion

	to_integer: INTEGER
		local
			i: INTEGER
		do
			from i := 1 until i > count loop
				Result := Result * 10 + (i_th_code (i).to_integer_32 - {ASCII}.Zero)
				i := i + 1
			end
		end

	to_string: ZSTRING
		do
			if attached String_32_pool.sufficient_item (count) as borrowed then
				if attached borrowed.empty as str_32 then
					append_to_string_32 (str_32)
					Result := str_32
				end
				borrowed.return
			end
		end

	to_string_32: STRING_32
		-- unicode string
		do
			if attached String_32_pool.sufficient_item (count) as borrowed then
				if attached borrowed.empty as str_32 then
					append_to_string_32 (str_32)
					Result := str_32.twin
				end
				borrowed.return
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

	set_from_integer (n: INTEGER)
		do
			if attached String_8_pool.borrowed_item as borrowed then
				if attached borrowed.empty as n_str then
					n_str.append_integer (n)
					set_from_string (n_str)
				end
				borrowed.return
			end
		end

	set_from_string (str: READABLE_STRING_GENERAL)
		do
			Setter.set_text (Current, str)
		ensure
			set: to_string_32.same_string_general (str)
		end

	wipe_out
		do
			cpp_clear (self_ptr)
		end

feature -- Basic operations

	append_to_string_32 (str: STRING_32)
		-- unicode string
		-- if `keep_ref' is `False', result is a shared instance
		local
			i, l_count: INTEGER; code: NATURAL; utf_16: EL_UTF_16_LE_CONVERTER
		do
			l_count := count
			str.grow (str.count + l_count)
			from i := 1 until i > l_count loop
				code := i_th_code (i)
				i := i + 1
				if utf_16.is_single_point (code) then
					str.extend (code.to_character_32)

				elseif i <= l_count then
					str.extend (utf_16.merged_points (code, i_th_code (i)).to_character_32)
					i := i + 1
				end
			end
		end

feature {TL_STRING_SETTER_I} -- Element change

	set_from_utf_16 (area: SPECIAL [NUMERIC])
		do
			wipe_out
			cpp_append (self_ptr, area.base_address)
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

	Setter: TL_STRING_SETTER_I [NUMERIC]
		once
			create {TL_STRING_SETTER_IMP} Result.make
		end

end