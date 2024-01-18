note
	description: "Implementation of ${EL_WAV_GENERATION_COMMAND_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_WAV_GENERATION_COMMAND_IMP

inherit
	EL_WAV_GENERATION_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_COMMAND_IMP

create
	make

feature -- Access

	Template: STRING = "[
		swgen -s $minimum_sample_rate -t ${duration} -w $output_file_path 
			$cycles_per_sec $frequency_lower $frequency_upper
	]"

end