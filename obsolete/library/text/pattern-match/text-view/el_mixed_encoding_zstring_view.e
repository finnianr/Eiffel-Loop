note
	description: "Mixed encoding zstring view"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-04 11:24:32 GMT (Monday 4th January 2021)"
	revision: "8"

class
	EL_MIXED_ENCODING_ZSTRING_VIEW

inherit
	EL_ZSTRING_VIEW
		redefine
			make, occurrences, z_code, unicode, to_string
		end

create
	make

feature {NONE} -- Initialization

	make (text: ZSTRING)
		require else
			valid_encoding: is_mixed_encoding implies text.has_mixed_encoding
		do
			Precursor (text)
			create unencoded.make (text.unencoded_area)
		end

feature -- Access

	to_string: EL_ZSTRING
		local
			l_unencoded: EL_EXTENDABLE_UNENCODED_CHARACTERS
			i, i_final: INTEGER
		do
			Result := Precursor
			l_unencoded := Result.empty_once_unencoded
			i_final := offset + count
			from i := offset until i = i_final loop
				l_unencoded.extend (unencoded.code (i + 1), i + 1)
				i := i + 1
			end
			l_unencoded.shift (offset.opposite)
			Result.set_from_extendible_unencoded (l_unencoded)
		end

feature -- Status query

	is_mixed_encoding: BOOLEAN
		do
			Result := True
		end

feature {NONE} -- Implementation

	occurrences (a_code: like z_code): INTEGER
		local
			l_area: like area; i, l_count: INTEGER; c, c_i: CHARACTER
		do
			l_area := area; l_count := count; c := a_code.to_character_8
			from i := 0 until i = l_count loop
				c_i := l_area [offset + i - 1]
				if c_i = Unencoded_character and then unencoded.z_code (i) = a_code then
					Result := Result + 1
				elseif c_i = c then
					Result := Result + 1
				end
				i := i + 1
			end
		end

	unicode (i: INTEGER): NATURAL_32
			-- Character at position `i'
		local
			c: CHARACTER_8
		do
			c := area [offset + i - 1]
			if c = Unencoded_character then
				Result := unencoded.code (offset + i)
			else
				Result := Codec.as_unicode_character (c).natural_32_code
			end
		end

	z_code (i: INTEGER): NATURAL_32
			-- Character at position `i'
		local
			c_i: CHARACTER
		do
			c_i := area [offset + i - 1]
			if c_i = Unencoded_character then
				Result := unencoded.z_code (offset + i)
			else
				Result := c_i.natural_32_code
			end
		end

feature {NONE} -- Internal attributes

	unencoded: EL_UNENCODED_CHARACTERS_INDEX

end
