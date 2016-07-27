note
	description: "Summary description for {EL_SUBSTRINGS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-27 10:18:15 GMT (Sunday 27th December 2015)"
	revision: "5"

deferred class
	EL_SUBSTRINGS [S -> READABLE_STRING_GENERAL]

inherit
	EL_SEQUENTIAL_INTERVALS
		rename
			make as  make_intervals
		end

feature {NONE} -- Initialization

	make (a_string: S; a_count: INTEGER)
			--
		do
			make_intervals (a_count)
			string := a_string
		end

feature -- Access

	string: S

	substring: S
			--
		do
			Result := string.substring (item_lower, item_upper)
		end

end