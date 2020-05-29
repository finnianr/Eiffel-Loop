note
	description: "Unix implementation of [$source EL_IP_ADAPTER_INFO_COMMAND_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-26 17:47:28 GMT (Tuesday 26th May 2020)"
	revision: "7"

class
	EL_IP_ADAPTER_INFO_COMMAND_IMP

inherit
	EL_IP_ADAPTER_INFO_COMMAND_I
		export
			{NONE} all
		redefine
			is_valid_platform
		end

	EL_OS_COMMAND_IMP
		undefine
			new_command_parts, do_command, make_default
		redefine
			is_valid_platform
		end

create
	make

feature {NONE} -- Status query

	is_valid_platform: BOOLEAN
		do
			Result := {PLATFORM}.is_unix
		end

feature {NONE} -- Constants

	Template: STRING = "nmcli --terse --fields GENERAL dev list"

end
