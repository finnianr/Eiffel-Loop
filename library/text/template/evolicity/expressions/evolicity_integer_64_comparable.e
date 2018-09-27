note
	description: "Evolicity integer 64 comparable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EVOLICITY_INTEGER_64_COMPARABLE

inherit
	EVOLICITY_COMPARABLE

create
	make_from_string

feature {NONE} -- Initialization

	make_from_string (string: ZSTRING)
			--
		require
			valid_string: string.is_integer_64
		do
			item := string.to_integer_64.to_reference
		end

end