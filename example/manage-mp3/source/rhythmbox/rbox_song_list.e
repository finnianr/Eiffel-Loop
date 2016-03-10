note
	description: "Summary description for {RBOX_ENTRY_ARRAY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	RBOX_SONG_LIST

inherit
	EL_FILTERABLE_ARRAYED_LIST [RBOX_SONG]
		redefine
			set_default_criteria
		end

create
	make, make_filled, make_from_array

feature -- Element change

	set_default_criteria
			--
		do
			reset_criteria
			add_negative_criteria (agent {RBOX_SONG}.is_hidden)
		end

end
