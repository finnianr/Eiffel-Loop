note
	description: "Command line interface to ${CLASS_NOTE_LINK_REFORMATTING_COMMAND}"
	notes: "[
			el_eiffel -class_note_link_reformatting -sources <directory or manifest path>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "2"

class
	CLASS_NOTE_LINK_REFORMATTING_APP

obsolete
	"Migrated from old [$source MY_CLASS] style link placeholders"

inherit
	SOURCE_MANIFEST_APPLICATION [CLASS_NOTE_LINK_REFORMATTING_COMMAND]

create
	make

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH})
		end

end
