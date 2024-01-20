note
	description: "Implementation of ${EL_AUDIO_PROPERTIES_COMMAND_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "7"

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