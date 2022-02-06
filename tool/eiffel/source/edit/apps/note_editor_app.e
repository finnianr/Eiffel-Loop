note
	description: "Command line interface to [$source NOTE_EDITOR_COMMAND]"
	notes: "[
		USAGE
			
			el_eiffel -note_editor -sources <path to manifest pyx> -licence <path to license pyx>
			
		This command edits the note fields of all classes defined by a source tree manifest argument
		by filling in default values for license fields listed in supplied `license' argument.
		If the modification date/time has changed, it fills in the note-fields.
		If changed, it sets the date note-field to be same as the time stamp and increments the
		revision number note-field.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-06 16:41:41 GMT (Sunday 6th February 2022)"
	revision: "30"

class
	NOTE_EDITOR_APP

inherit
	SOURCE_MANIFEST_APPLICATION [NOTE_EDITOR_COMMAND]

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH})
		end

end