note
	description: "Source manifest editor command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:52:09 GMT (Monday 3rd January 2022)"
	revision: "6"

deferred class
	SOURCE_MANIFEST_EDITOR_COMMAND

inherit
	SOURCE_MANIFEST_COMMAND
		redefine
			make
		end

feature {NONE} -- Initialization

	make (source_manifest_path: FILE_PATH)
		do
			Precursor (source_manifest_path)
			editor := new_editor
		end

feature -- Basic operations

	process_file (source_path: FILE_PATH)
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
