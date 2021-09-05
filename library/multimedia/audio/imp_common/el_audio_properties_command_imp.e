note
	description: "Implementation of [$source EL_AUDIO_PROPERTIES_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-01 9:34:13 GMT (Wednesday 1st September 2021)"
	revision: "5"

class
	EL_AUDIO_PROPERTIES_COMMAND_IMP

inherit
	EL_AUDIO_PROPERTIES_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_COMMAND_IMP
		undefine
			on_error
		end

create
	make

feature {NONE} -- Constants

	Template: STRING = "$command_name -i $file_path"

end