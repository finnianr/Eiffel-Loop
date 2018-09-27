note
	description: "Evolicity double comparable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EVOLICITY_DOUBLE_COMPARABLE

inherit
	EVOLICITY_COMPARABLE

create
	make_from_string

feature {NONE} -- Initialization

	make_from_string (string: ZSTRING)
			--
		require
			valid_string: string.is_double
		do
			item := string.to_double.to_reference
		end

end