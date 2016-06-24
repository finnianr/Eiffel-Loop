note
	description: "Implementation of `EL_AUDIO_PROPERTIES_COMMAND_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-22 17:29:15 GMT (Wednesday 22nd June 2016)"
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
			make_default, on_error
		end

create
	make

feature {NONE} -- Constants

	Template: STRING = "$command_name -i $file_path"

end
