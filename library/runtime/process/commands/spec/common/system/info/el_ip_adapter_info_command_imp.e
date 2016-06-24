note
	description: "Implementation of `EL_IP_ADAPTER_INFO_COMMAND_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-21 9:26:47 GMT (Tuesday 21st June 2016)"
	revision: "4"

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
