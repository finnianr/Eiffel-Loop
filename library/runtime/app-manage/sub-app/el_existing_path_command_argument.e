note
	description: "Summary description for {EL_EXISTING_PATH_COMMAND_ARGUMENT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-30 4:08:09 GMT (Tuesday 30th May 2017)"
	revision: "1"

class
	EL_EXISTING_PATH_COMMAND_ARGUMENT

inherit
	EL_REQUIRED_COMMAND_ARGUMENT
		redefine
			path_exists
		end

create
	make

feature {NONE} -- Constants

	Path_exists: BOOLEAN = True

end
