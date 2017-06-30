note
	description: "Summary description for {EIFFEL_EDITING_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-29 11:33:05 GMT (Thursday 29th June 2017)"
	revision: "2"

class
	EDITING_COMMAND

inherit
	EL_FILE_PROCESSING_COMMAND

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

	file_path: EL_FILE_PATH

end
