note
	description: "Summary description for {EL_WAV_GENERATION_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-18 13:25:05 GMT (Saturday 18th June 2016)"
	revision: "1"

class
	EL_WAV_GENERATION_COMMAND_IMPL

inherit
	EL_OS_COMMAND_IMPL

feature -- Access

	Template: STRING = "swgen -s $sample_rate -t ${duration} -w $output_file_path $cycles_per_sec $frequency_lower $frequency_upper"

end