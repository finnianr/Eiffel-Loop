note
	description: "Implementation of [$source EL_AUDIO_PROPERTIES_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 17:25:47 GMT (Wednesday 21st February 2018)"
	revision: "3"

class
	EL_AUDIO_PROPERTIES_COMMAND_IMP

inherit
	EL_AUDIO_PROPERTIES_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_COMMAND_IMP
		undefine
			make_default, on_error
		end

create
	make

feature {NONE} -- Constants

	Template: STRING = "$command_name -i $file_path"

end
