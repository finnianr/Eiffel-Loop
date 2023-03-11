note
	description: "File processing command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-10 10:10:55 GMT (Friday 10th March 2023)"
	revision: "9"

deferred class
	EL_FILE_PROCESSING_COMMAND

inherit
	EL_COMMAND

feature -- Basic operations

	execute
		deferred
		end

feature -- Element change

	set_file_path (a_file_path: FILE_PATH)
		deferred
		end

end