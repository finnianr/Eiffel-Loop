note
	description: "Implementation of `EL_WAV_GENERATION_COMMAND_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-23 8:35:47 GMT (Thursday 23rd June 2016)"
	revision: "5"

class
	EL_WAV_GENERATION_COMMAND_IMP

inherit
	EL_WAV_GENERATION_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_COMMAND_IMP
		undefine
			make_default
		end

create
	make

feature -- Access

	Template: STRING = "[
		swgen -s $minimum_sample_rate -t ${duration} -w $output_file_path 
			$cycles_per_sec $frequency_lower $frequency_upper
	]"

end
