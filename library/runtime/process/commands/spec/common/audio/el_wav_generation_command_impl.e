note
	description: "Summary description for {EL_WAV_GENERATION_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-09-15 12:20:57 GMT (Tuesday 15th September 2015)"
	revision: "5"

class
	EL_WAV_GENERATION_COMMAND_IMPL

inherit
	EL_COMMAND_IMPL

create
	make

feature -- Access

	Template: STRING = "swgen -s $sample_rate -t ${duration}m -w $output_file_path $cycles_per_sec $frequency_lower $frequency_upper"

end
