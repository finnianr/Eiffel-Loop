note
	description: "Default file processing command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-13 13:00:06 GMT (Thursday 13th January 2022)"
	revision: "3"

class
	EL_DEFAULT_FILE_PROCESSING_COMMAND

inherit
	EL_FILE_PROCESSING_COMMAND
		rename
			default_description as  description
		end

feature -- Basic operations

	execute
		do
		end

feature -- Element change

 	set_file_path (a_file_path: FILE_PATH)
 		do
 		end

end