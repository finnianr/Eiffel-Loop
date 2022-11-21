note
	description: "A mutable substring view of characters in a [$source STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "10"

class
	EL_STRING_8_VIEW

inherit
	EL_STRING_VIEW
		redefine
			make, to_string_8
		end

create
	make

convert
	make ({STRING})

feature {NONE} -- Initialization

	make (text: STRING)
			-- Copied from {STRING}.share
		do
			Precursor (text)
			area := text.area
		end

feature -- Access

	code (i: INTEGER): NATURAL_32
			-- Character at position `i'
		do
			Result := area.item (offset + i - 1).natural_32_code
		end

	code_at_absolute (i: INTEGER): NATURAL_32
			-- Character at position `i'
		do
			Result := area.item (i - 1).natural_32_code
		end

	occurrences (c: like code): INTEGER
		local
			l_area: like area; i, i_final: INTEGER
		do
			l_area := area; i_final := offset + count
			from i := offset until i = i_final loop
				if l_area.item (i).natural_32_code = c then
					Result := Result + 1
				end
				i := i + 1
			end
		end

	to_string_general, to_string_8: STRING
		do
			create Result.make_filled ('%U', count)
			Result.area.copy_data (area, offset, 0, count)
		end

feature -- Basic operations

	append_to_string_8 (output: STRING_8)
		local
			old_count, new_count: INTEGER
		do
			old_count := output.count; new_count := old_count + count
			output.grow (new_count)
			output.area.copy_data (area, offset, old_count, count)
			output.set_count (new_count)
		end

feature -- Status query

	has (uc: CHARACTER_32): BOOLEAN
		local
			l_area: like area; i, i_final: INTEGER
			c: CHARACTER
		do
			c := uc.to_character_8
			l_area := area; i_final := offset + count
			from i := offset until Result or else i = i_final loop
				if l_area [i] = c then
					Result := True
				end
				i := i + 1
			end
		end

feature {NONE} -- Internal attributes

	area: like to_string_8.area

end