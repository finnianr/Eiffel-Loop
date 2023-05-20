note
	description: "Implementation of [$source EL_EXTRACT_MP3_INFO_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-20 9:20:15 GMT (Saturday 20th May 2023)"
	revision: "8"

class
	EL_EXTRACT_MP3_INFO_COMMAND_IMP

inherit
	EL_EXTRACT_MP3_INFO_COMMAND_I
		export
			{NONE} all
		redefine
			is_valid_platform
		end

	EL_OS_CAPTURED_COMMAND_IMP
		undefine
			make_default
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