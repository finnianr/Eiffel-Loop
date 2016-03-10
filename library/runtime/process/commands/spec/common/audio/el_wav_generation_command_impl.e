note
	description: "Summary description for {EL_WAV_GENERATION_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-01-27 11:51:09 GMT (Monday 27th January 2014)"
	revision: "3"

class
	EL_WAV_GENERATION_COMMAND_IMPL

inherit
	EL_COMMAND_IMPL

create
	make

feature -- Access

	Template: STRING = "[
		swgen -s $sample_rate -t ${duration}m -w "$output_file_path" $cycles_per_sec $frequency_lower $frequency_upper
	]"

end
