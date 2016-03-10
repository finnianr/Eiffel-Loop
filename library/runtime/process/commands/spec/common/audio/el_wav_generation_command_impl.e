note
	description: "Summary description for {EL_WAV_GENERATION_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-16 18:18:43 GMT (Sunday 16th June 2013)"
	revision: "2"

class
	EL_WAV_GENERATION_COMMAND_IMPL

inherit
	EL_COMMAND_IMPL

feature -- Access

	template: STRING = "[
		swgen -s $sample_rate -t ${duration}m -w "$output_file_path" $cycles_per_sec $frequency_lower $frequency_upper
	]"

end
