note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-03 18:59:01 GMT (Wednesday 3rd August 2016)"
	revision: "2"

deferred class
	EL_FILE_PROCESSING_COMMAND

inherit
	EL_COMMAND

feature -- Basic operations

	execute
		deferred
		end

feature -- Element change

 	set_file_path (a_file_path: EL_FILE_PATH)
 		deferred
 		end

end
