note
	description: "Summary description for {EL_EIFFEL_SOURCE_MANIFEST_EDITOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-20 11:30:05 GMT (Saturday 20th July 2013)"
	revision: "2"

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
			file_editor := create_file_editor
		end

feature -- Basic operations

	process_file (source_path: EL_FILE_PATH)
		do
			file_editor.set_input_file_path (source_path)
			file_editor.edit_file
		end

feature {NONE} -- Implementation

	file_editor: EIFFEL_SOURCE_EDITING_PROCESSOR

	create_file_editor: EIFFEL_SOURCE_EDITING_PROCESSOR
		deferred
		end

end
