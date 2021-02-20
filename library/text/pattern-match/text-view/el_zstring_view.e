note
	description: "A mutable substring view of characters in a [$source EL_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-19 13:12:22 GMT (Friday 19th February 2021)"
	revision: "15"

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

	EL_ZSTRING_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (text: ZSTRING)
		do
			area := text.area
			Precursor (text)
			if text.has_mixed_encoding then
				create unencoded_indexable.make (text.unencoded_area)
			end
		end

feature -- Access

	unicode (i: INTEGER): NATURAL_32
			-- Character at position `i'
		local
			c: CHARACTER_8
		do
			c := area [offset + i - 1]
			if c = Unencoded_character and then attached unencoded_indexable as unencoded then
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
			if c_i = Unencoded_character and then attached unencoded_indexable as unencoded then
				Result := unencoded.z_code (i)
			else
				Result := c_i.natural_32_code
			end
		end

feature -- Measurement

	occurrences (a_code: like z_code): INTEGER
		local
			l_area: like area; i, i_final: INTEGER; c, c_i: CHARACTER
		do
			l_area := area; i_final := offset + count
			c := a_code.to_character_8
			if attached unencoded_indexable as unencoded then
				from i := offset until i = i_final loop
					c_i := l_area [i]
					if c_i = Unencoded_character and then unencoded.z_code (i + 1) = a_code then
						Result := Result + 1
					elseif c_i = c then
						Result := Result + 1
					end
					i := i + 1
				end
			else
				from i := offset until i = i_final loop
					if l_area [i] = c then
						Result := Result + 1
					end
					i := i + 1
				end
			end
		end

feature -- Conversion

	to_string: EL_ZSTRING
		local
			i, i_final: INTEGER; l_area: like area
		do
			l_area := area
			create Result.make (count)
			Result.area.copy_data (l_area, offset, 0, count)
			Result.set_count (count)
			if attached unencoded_indexable as unencoded
				and then attached Result.empty_unencoded_buffer as buffer
			then
				i_final := offset + count
				from i := offset until i = i_final loop
					if l_area [i] = Unencoded_character then
						buffer.extend (unencoded.code (i + 1), i + 1)
					end
					i := i + 1
				end
				buffer.shift (offset.opposite)
				Result.set_unencoded_from_buffer (buffer)
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
			i, old_count, new_count, area_lower, area_upper, index: INTEGER; l_area: like area
		do
			if attached {ZSTRING} str as zstr then
				old_count := zstr.count; new_count := old_count + count
				zstr.grow (new_count)
				zstr.area.copy_data (area, offset, old_count, count)
				zstr.set_count (new_count)

				if attached unencoded_indexable as unencoded
					and then attached Empty_string.empty_unencoded_buffer as buffer
				then
					l_area := area
					area_lower := start_index + offset - 1
					area_upper := end_index.min (count) + offset - 1
					from i := area_lower until i > area_upper loop
						if l_area [i] = Unencoded_character then
							index := i - start_index + 2
							buffer.extend (unencoded.code (index), index)
						end
						i := i + 1
					end
					zstr.append_unencoded (buffer, old_count - offset)
					buffer.set_in_use (False)
				end
			else
				from i := start_index until i > end_index or else i > count loop
					str.append_code (unicode (i))
					i := i + 1
				end
			end
		end

feature -- Status query

	has (uc: CHARACTER_32): BOOLEAN
		-- `True' is string contains at least one `uc'?
		local
			l_area: like area; i, i_final: INTEGER; c, c_i: CHARACTER
			l_code: NATURAL
		do
			c := Codec.encoded_character (uc.natural_32_code)
			l_area := area; i_final := offset + count
			if c = Unencoded_character and then attached unencoded_indexable as unencoded then
				l_code := Codec.as_z_code (uc)
				from i := offset until Result or else i = i_final loop
					c_i := l_area [i]
					if c_i = Unencoded_character and then unencoded.z_code (i + 1) = l_code then
						Result := True
					end
					i := i + 1
				end
			else
				from i := offset until Result or else i = i_final loop
					if l_area [i] = c then
						Result := True
					end
					i := i + 1
				end
			end
		end

feature {NONE} -- Internal attributes

	area: SPECIAL [CHARACTER_8]

	unencoded_indexable: detachable EL_UNENCODED_CHARACTERS_INDEX

end
