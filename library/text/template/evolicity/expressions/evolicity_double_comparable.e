note
	description: "Summary description for {EVOLICITY_DOUBLE_COMPARABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

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