note
	description: "Unix implementation of [$source EL_DELETION_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 17:27:47 GMT (Wednesday 21st February 2018)"
	revision: "3"

class
	EL_DELETE_FILE_COMMAND_IMP

inherit
	EL_DELETE_FILE_COMMAND_I

	EL_OS_COMMAND_IMP
		undefine
			make_default
		end

create
	make, make_default

feature {NONE} -- Constants

	Template: STRING = "rm $target_path"

end
