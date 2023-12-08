note
	description: "[$source FORMAT_DOUBLE] with ability to initialize from a format likeness string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-08 10:04:45 GMT (Friday 8th December 2023)"
	revision: "2"

class
	EL_FORMAT_DOUBLE

inherit
	FORMAT_DOUBLE
		rename
			make as make_sized
		redefine
			formatted
		end

	EL_FORMAT_LIKENESS

create
	make, make_sized

convert
	make ({STRING_8})

feature -- Conversion

	formatted (d: DOUBLE): STRING
		do
			Result := Precursor (d)
			if is_percentile then
				insert_percent (Result)
			end
		end

feature {NONE} -- Implementation

	parsed_decimal_count (parser: EL_SIMPLE_IMMUTABLE_PARSER_8; decimal_point: CHARACTER_REF): INTEGER
		do
			parser.reset_count_removed
			across ".," as c until parser.was_removed loop
				decimal_point.set_item (c.item)
				parser.try_remove_right_until (decimal_point.item)
				if parser.was_removed then
					Result := parser.count_removed - 1
				end
			end
		end

	set_decimal_point (c: CHARACTER)
		do
			decimal := c
		end

end