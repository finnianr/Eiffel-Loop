note
	description: "Implementation of [$source EL_MP3_TO_WAV_CLIP_SAVER_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 17:26:02 GMT (Wednesday 21st February 2018)"
	revision: "3"

class
	EL_MP3_TO_WAV_CLIP_SAVER_COMMAND_IMP

inherit
	EL_MP3_TO_WAV_CLIP_SAVER_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_COMMAND_IMP
		undefine
			make_default
		end

create
	make

feature {NONE} -- Implementation

	Template: STRING = "[
		$command_name -i $input_file_path -loglevel ${log_level} -ss $offset -t ${duration}.1 $output_file_path
	]"
	-- Note: duration has extra 0.1 secs added to prevent rounding error below the required duration

end
