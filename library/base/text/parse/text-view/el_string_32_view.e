note
	description: "String 32 view"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_STRING_32_VIEW

inherit
	EL_STRING_VIEW
		redefine
			make, to_string_32
		end

create
	make

convert
	make ({STRING_32})

feature {NONE} -- Initialization

	make (text: STRING_32)
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
			l_area: like area; i: INTEGER
		do
			l_area := area
			from i := 1 until i > count loop
				if l_area.item (offset + i - 1).natural_32_code = c then
					Result := Result + 1
				end
				i := i + 1
			end
		end

	to_string_general, to_string_32: STRING_32
		do
			create Result.make_filled ('%U', count)
			Result.area.copy_data (area, offset, 0, count)
		end

feature {NONE} -- Internal attributes

	area: like to_string_32.area

end