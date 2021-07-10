note
	description: "Windows implementation of [$source EL_CREATE_LINK_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-10 14:50:30 GMT (Saturday 10th July 2021)"
	revision: "2"

class
	EL_CREATE_LINK_COMMAND_IMP

inherit
	EL_CREATE_LINK_COMMAND_I

	EL_OS_COMMAND_IMP
		undefine
			make_default
		end

create
	make, make_default

feature {NONE} -- Constants

	Template: STRING = "[
		mklink $link_path $target_path
	]"
end