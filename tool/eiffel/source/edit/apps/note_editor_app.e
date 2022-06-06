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
	date: "2022-06-06 8:19:04 GMT (Monday 6th June 2022)"
	revision: "31"

class
	NOTE_EDITOR_APP

inherit
	SOURCE_MANIFEST_APPLICATION [NOTE_EDITOR_COMMAND]
		redefine
			argument_list
		end

feature {NONE} -- Implementation

	argument_list: EL_ARRAYED_LIST [EL_COMMAND_ARGUMENT]
		-- for use with when modifiying `argument_specs' in descendant
		do
			Result := Precursor +
				optional_argument ("cpu_percentage", "Percentage of CPU resources to use", No_checks)
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH}, 100)
		end

end