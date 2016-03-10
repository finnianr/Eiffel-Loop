note
	description: "Summary description for {EL_CPU_INFO_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-11-14 17:45:06 GMT (Thursday 14th November 2013)"
	revision: "3"

class
	EL_AUDIO_PROPERTIES_COMMAND_IMPL

inherit
	EL_VIDEO_CONVERSION_COMMAND_IMPL

create
	make

feature -- Access

	Command_arguments: STRING = "[
		-i "$file_path"
	]"

end
