note
	description: "Source manifest editor command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-30 13:56:13 GMT (Sunday 30th March 2025)"
	revision: "12"

deferred class
	SOURCE_MANIFEST_EDITOR_COMMAND

inherit
	SOURCE_MANIFEST_COMMAND
		redefine
			make
		end

	EL_STRING_GENERAL_ROUTINES_I

feature {EL_COMMAND_CLIENT} -- Initialization

	make (source_manifest_path: FILE_PATH)
		do
			Precursor (source_manifest_path)
			editor := new_editor
		end

feature {NONE} -- Implementation

	do_with_file (source_path: FILE_PATH)
		do
			editor.set_file_path (source_path)
			editor.edit
		end

feature {NONE} -- Implementation

	editor: like new_editor

	new_editor: EL_EIFFEL_SOURCE_EDITOR
		deferred
		end

end