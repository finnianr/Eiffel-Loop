note
	description: "Windows implementation of ${EL_COPY_FILE_COMMAND_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-18 7:41:27 GMT (Wednesday 18th September 2024)"
	revision: "9"

class
	EL_COPY_FILE_COMMAND_IMP

inherit
	EL_COPY_FILE_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_COMMAND_IMP

create
	make, make_default

feature {NONE} -- Constants

	Template: STRING = "copy $source_path $destination_path > NUL"
end