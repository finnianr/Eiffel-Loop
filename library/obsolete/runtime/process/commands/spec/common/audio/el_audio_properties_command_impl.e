note
	description: "Summary description for {EL_CPU_INFO_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-05-16 17:31:31 GMT (Monday 16th May 2016)"
	revision: "5"

class
	EL_AUDIO_PROPERTIES_COMMAND_IMPL

inherit
	EL_VIDEO_CONVERSION_COMMAND_IMPL
		redefine
			file_redirection_operator
		end

feature -- Access

	Command_arguments: STRING = "-i $file_path"

feature {NONE} -- Constants

	File_redirection_operator: STRING
		once
			Result := " 2>> "
		end

end