note
	description: "A mutable substring view of characters in a [$source EL_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-05 9:20:33 GMT (Tuesday 5th January 2021)"
	revision: "9"

class
	EL_ZSTRING_VIEW

inherit
	EL_STRING_VIEW
		rename
			code as z_code,
			code_at_absolute as z_code_at_absolute
		redefine
			append_substring_to, make, to_string, to_string_8
		end

	EL_ZCODE_CONVERSION

	EL_SHARED_ZSTRING_CODEC

create
	make

feature {NONE} -- Initialization

	make (text: ZSTRING)
		do
			area := text.area
			Precursor (text)
			if text.has_mixed_encoding then
				create unencoded_index.make (text.unencoded_area)
			end
		end

feature -- Access

	unicode (i: INTEGER): NATURAL_32
			-- Character at position `i'
		local
			c: CHARACTER_8
		do
			c := area [offset + i - 1]
			if c = Unencoded_character and then attached unencoded_index as unencoded then
				Result := unencoded.code (offset + i)
			else
				Result := Codec.as_unicode_character (c).natural_32_code
			end
		end

	z_code (i: INTEGER): NATURAL_32
			-- Character at position `i' relative to `offset'
		do
			Result := z_code_at_absolute (offset + i)
		end

	z_code_at_absolute (i: INTEGER): NATURAL_32
			-- Character at absolute position `i'
		local
			c_i: CHARACTER
		do
			c_i := area [i - 1]
			if c_i = Unencoded_character and then attached unencoded_index as unencoded then
				Result := unencoded.z_code (i)
			else
				Result := c_i.natural_32_code
			end
		end

feature -- Measurement

	occurrences (a_code: like z_code): INTEGER
		local
			l_area: like area; i, l_count: INTEGER; c, c_i: CHARACTER
		do
			l_area := area; l_count := count
			c := a_code.to_character_8
			if attached unencoded_index as unencoded then
				from i := 0 until i = l_count loop
					c_i := l_area [offset + i - 1]
					if c_i = Unencoded_character and then unencoded.z_code (i) = a_code then
						Result := Result + 1
					elseif c_i = c then
						Result := Result + 1
					end
					i := i + 1
				end
			else
				from i := 0 until i = l_count loop
					if l_area.item (offset + i - 1) = c then
						Result := Result + 1
					end
					i := i + 1
				end
			end
		end

feature -- Conversion

	to_string: EL_ZSTRING
		local
			i, i_final: INTEGER
		do
			create Result.make (count)
			Result.area.copy_data (area, offset, 0, count)
			Result.set_count (count)
			if attached unencoded_index as unencoded
				and then attached Result.empty_once_unencoded as once_unencoded
			then
				i_final := offset + count
				from i := offset until i = i_final loop
					once_unencoded.extend (unencoded.code (i + 1), i + 1)
					i := i + 1
				end
				once_unencoded.shift (offset.opposite)
				Result.set_from_extendible_unencoded (once_unencoded)
			end
		end

	to_string_8: STRING
		do
			Result := to_string.to_latin_1
		end

	to_string_general: READABLE_STRING_GENERAL
		do
			Result := to_string.to_unicode
		end

feature -- Basic operations

	append_substring_to (str: STRING_GENERAL; start_index, end_index: INTEGER)
		local
			i: INTEGER
		do
			if attached {ZSTRING} str as zstr then
				zstr.grow (end_index - start_index + 1 + zstr.count)
				from i := start_index until i > end_index or else i > count loop
					zstr.append_z_code (z_code (i))
					i := i + 1
				end
			else
				from i := start_index until i > end_index or else i > count loop
					str.append_code (unicode (i))
					i := i + 1
				end
			end
		end

feature {NONE} -- Internal attributes

	area: SPECIAL [CHARACTER_8]

	unencoded_index: detachable EL_UNENCODED_CHARACTERS_INDEX

end