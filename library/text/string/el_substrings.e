note
	description: "Summary description for {EL_SUBSTRINGS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-28 10:24:30 GMT (Sunday 28th July 2013)"
	revision: "3"

deferred class
	EL_SUBSTRINGS

inherit
	LINEAR [INTEGER_INTERVAL]
		rename
			item as interval
		end

feature {NONE} -- Initialization

	make (a_string: EL_ASTRING)
			--
		do
			create string.make_empty
			string.share (a_string)
		end

feature -- Access

	string: EL_ASTRING

	substring: EL_ASTRING
			--
		do
			Result := string.substring (interval.lower, interval.upper)
		end

end