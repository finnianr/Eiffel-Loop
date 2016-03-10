note
	description: "Summary description for {EL_WAV_FADER_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-16 18:19:06 GMT (Sunday 16th June 2013)"
	revision: "2"

class
	EL_WAV_FADER_IMPL

inherit
	EL_COMMAND_IMPL

feature -- Access

	template: STRING = "[
		sox "$input_file_path" "$output_file_path" fade t $fade_in $duration $fade_out
	]"

end
