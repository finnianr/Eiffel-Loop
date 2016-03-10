note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

deferred class
	EL_FILE_PROCESSOR

inherit
	EL_COMMAND
	
feature -- Access

	file_path: EL_FILE_PATH

feature -- Basic operations

	execute
		deferred
		end

feature -- Element change

 	set_file_path (a_file_path: like file_path)
 			--
 		do
 			file_path := a_file_path
 		end

end -- class EL_FILE_PROCESSOR

