note
	description: ""

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-03 17:06:59 GMT (Wednesday 3rd August 2016)"
	revision: "2"

deferred class
	EL_FILE_EDITING_PROCESSOR

inherit
	EL_FILE_PARSER_TEXT_FILE_EDITOR

	EL_FILE_PROCESSING_COMMAND
		rename
			execute as edit
		end

feature {NONE} -- Initialization

 	make_from_file (a_file_path: EL_FILE_PATH)
 			--
 		do
 			make_default
 			set_file_path (a_file_path)
 		end

end
