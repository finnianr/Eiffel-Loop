note
	description: "Summary description for {EVOLICITY_DOUBLE_COMPARABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 13:00:54 GMT (Wednesday 16th December 2015)"
	revision: "3"

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
