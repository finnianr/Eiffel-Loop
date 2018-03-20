note
	description: "Implementation of [$source EL_IP_ADAPTER_INFO_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 17:27:12 GMT (Wednesday 21st February 2018)"
	revision: "3"

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
			new_command_string, do_command, make_default
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

	Template: STRING = "nm-tool"

end
