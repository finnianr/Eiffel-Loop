note
	description: "[$source FORMAT_DOUBLE] with ability to initialize from a format likeness string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-07 13:24:24 GMT (Thursday 7th December 2023)"
	revision: "1"

class
	EL_FORMAT_DOUBLE

inherit
	FORMAT_DOUBLE
		rename
			make as make_sized
		end

	EL_FORMAT_LIKENESS

create
	make, make_sized

convert
	make ({STRING_8})

feature {NONE} -- Implementation

	parsed_decimal_count (parser: EL_SIMPLE_IMMUTABLE_PARSER_8): INTEGER
		do
			parser.reset_count_removed
			across ".," as decimal_separator until parser.was_removed loop
				parser.try_remove_right_until (decimal_separator.item)
				if parser.was_removed then
					Result := parser.count_removed - 1
				end
			end
		end

end