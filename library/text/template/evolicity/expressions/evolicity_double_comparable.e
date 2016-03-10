note
	description: "Summary description for {EVOLICITY_DOUBLE_COMPARABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EVOLICITY_DOUBLE_COMPARABLE

inherit
	EVOLICITY_COMPARABLE

create
	make_from_string

feature {NONE} -- Initialization

	make_from_string (string: STRING)
			--
		require
			valid_string: string.is_double
		do
			item := string.to_double.to_reference
		end

end
