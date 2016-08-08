note
	description: "Summary description for {EL_EIFFEL_SOURCE_MANIFEST_EDITOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-03 17:12:37 GMT (Wednesday 3rd August 2016)"
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
			editor := new_editor
		end

feature -- Basic operations

	process_file (source_path: EL_FILE_PATH)
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
