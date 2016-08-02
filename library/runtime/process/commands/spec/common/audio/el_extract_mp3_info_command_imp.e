note
	description: "Implementation of `EL_EXTRACT_MP3_INFO_COMMAND_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-21 9:25:46 GMT (Tuesday 21st June 2016)"
	revision: "1"

class
	EL_EXTRACT_MP3_INFO_COMMAND_IMP

inherit
	EL_EXTRACT_MP3_INFO_COMMAND_I
		export
			{NONE} all
		redefine
			is_valid_platform
		end

	EL_OS_COMMAND_IMP
		undefine
			do_command, make_default, new_command_string
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

feature {NONE} -- Implementation

	Template: STRING_32 = "extract $path"

end