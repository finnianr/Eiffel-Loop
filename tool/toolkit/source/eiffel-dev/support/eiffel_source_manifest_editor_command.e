note
	description: "Summary description for {EL_EIFFEL_SOURCE_MANIFEST_EDITOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-20 9:41:53 GMT (Wednesday 20th January 2016)"
	revision: "6"

deferred class
	EIFFEL_SOURCE_MANIFEST_EDITOR_COMMAND

inherit
	EIFFEL_SOURCE_MANIFEST_COMMAND
		redefine
			make
		end

feature {NONE} -- Initialization

	make (source_manifest_path: EL_FILE_PATH)
		do
			Precursor (source_manifest_path)
			file_editor := new_file_editor
		end

feature -- Basic operations

	process_file (source_path: EL_FILE_PATH)
		do
			file_editor.set_input_file_path (source_path)
			file_editor.edit
		end

feature {NONE} -- Implementation

	file_editor: EIFFEL_SOURCE_EDITING_PROCESSOR

	new_file_editor: EIFFEL_SOURCE_EDITING_PROCESSOR
		deferred
		end

end