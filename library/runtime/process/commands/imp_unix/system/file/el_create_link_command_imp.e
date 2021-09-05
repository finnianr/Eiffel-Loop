note
	description: "Unix implementation of [$source EL_CREATE_LINK_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-01 9:25:14 GMT (Wednesday 1st September 2021)"
	revision: "2"

class
	EL_CREATE_LINK_COMMAND_IMP

inherit
	EL_CREATE_LINK_COMMAND_I

	EL_OS_COMMAND_IMP

create
	make, make_default

feature {NONE} -- Constants

	Template: STRING = "[
		ln --force --symbolic $target_path $link_path
	]"
end