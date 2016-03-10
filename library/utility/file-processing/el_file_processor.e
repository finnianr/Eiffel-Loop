note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:35:01 GMT (Tuesday 18th June 2013)"
	revision: "2"

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

