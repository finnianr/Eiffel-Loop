note
	description: "Mixed encoding zstring view"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_MIXED_ENCODING_ZSTRING_VIEW

inherit
	EL_ZSTRING_VIEW
		redefine
			make, is_mixed_encoding, occurrences, z_code
		end

create
	make

feature {NONE} -- Initialization

	make (a_text: like text)
		require else
			valid_encoding: is_mixed_encoding implies a_text.has_mixed_encoding
		do
			Precursor (a_text)
			create unencoded.make (text.unencoded_area)
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

	unencoded: like text.unencoded_interval_index

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

feature {NONE} -- Constants

	Unencoded_character: CHARACTER = '%/026/'

end