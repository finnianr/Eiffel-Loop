note
	description: "File processing command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-23 11:03:40 GMT (Sunday 23rd December 2018)"
	revision: "5"

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
