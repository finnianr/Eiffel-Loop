note
	description: "Summary description for {EL_VIDEO_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-05-16 15:39:10 GMT (Monday 16th May 2016)"
	revision: "1"

deferred class
	EL_VIDEO_CONVERSION_COMMAND_IMPL

inherit
	EL_OS_COMMAND_IMPL

feature {NONE} -- Implementation

	avconv_path: EL_FILE_PATH
		do
			Result := "C:/Program files/avconv"
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