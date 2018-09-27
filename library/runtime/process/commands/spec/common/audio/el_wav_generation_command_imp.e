note
	description: "Implementation of [$source EL_WAV_GENERATION_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "4"

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
