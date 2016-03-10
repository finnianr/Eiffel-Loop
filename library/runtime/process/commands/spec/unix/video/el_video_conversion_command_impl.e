note
	description: "Summary description for {EL_VIDEO_COMMAND_IMPL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
