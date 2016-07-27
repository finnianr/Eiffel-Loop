note
	description: "Unix implementation of `EL_COPY_FILE_COMMAND_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-19 12:00:19 GMT (Sunday 19th June 2016)"
	revision: "5"

class
	EL_COPY_FILE_COMMAND_IMP

inherit
	EL_COPY_FILE_COMMAND_I

	EL_OS_COMMAND_IMP
		undefine
			make_default
		end

	EL_UNIX_CP_TEMPLATE

create
	make, make_default

end