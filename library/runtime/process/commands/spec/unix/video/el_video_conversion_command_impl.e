note
	description: "Summary description for {EL_VIDEO_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-17 15:54:53 GMT (Wednesday 17th December 2014)"
	revision: "3"

deferred class
	EL_VIDEO_CONVERSION_COMMAND_IMPL

inherit
	EL_COMMAND_IMPL

feature {NONE} -- Implementation

	avconv_path: EL_FILE_PATH
		do
			Result := "/usr/bin/avconv"
		end

	template: STRING
		do
			Result := Command_stem + command_arguments
		end

	command_arguments: STRING
		deferred
		end

feature {NONE} -- Constants

	Command_stem: STRING
		once
			if avconv_path.exists then
				Result := "avconv "
			else
				Result := "ffmpeg "
			end
		end

end
