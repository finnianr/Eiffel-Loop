note
	description: "Editing command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-03 12:52:54 GMT (Thursday 3rd February 2022)"
	revision: "7"

class
	EDITING_COMMAND

inherit
	EL_FILE_PROCESSING_COMMAND
		rename
			default_description as description
		end

create
	make

feature {NONE} -- Initialization

	make (a_editor: like editor)
		do
			editor := a_editor
		end

feature -- Basic operations

	execute
		do
			editor.edit
		end

feature -- Element change

 	set_file_path (a_file_path: like file_path)
 		do
 			editor.set_file_path (a_file_path)
 		end

feature {NONE} -- Internal attributes

	editor: EL_EIFFEL_SOURCE_EDITOR

	file_path: FILE_PATH

end