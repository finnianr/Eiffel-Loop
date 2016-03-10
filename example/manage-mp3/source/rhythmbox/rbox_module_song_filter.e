note
	description: "Summary description for {RBOX_MODULE_SONG_FILTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	RBOX_MODULE_SONG_FILTER

inherit
	EL_MODULE

feature -- Access

	Song_filter: RBOX_SONG_FILTERS
		once
			create Result
		end

end
