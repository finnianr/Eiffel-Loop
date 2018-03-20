note
	description: "Checks for invalid class references in note links"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 12:29:23 GMT (Wednesday 21st February 2018)"
	revision: "1"

class
	REPOSITORY_NOTE_LINK_CHECKER_APP

inherit
	REPOSITORY_PUBLISHER_SUB_APPLICATION [REPOSITORY_NOTE_LINK_CHECKER]
		redefine
			Option_name
		end

feature {NONE} -- Implementation

	default_make: PROCEDURE
		do
			Result := agent {like command}.make ("", "", 0)
		end

feature {NONE} -- Constants

	Option_name: STRING = "check_note_links"

	Description: STRING = "Checks for invalid class references in repository note links"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{REPOSITORY_NOTE_LINK_CHECKER_APP}, All_routines],
				[{REPOSITORY_SOURCE_TREE}, All_routines],
				[{REPOSITORY_SOURCE_TREE_PAGE}, All_routines]
			>>
		end

end
