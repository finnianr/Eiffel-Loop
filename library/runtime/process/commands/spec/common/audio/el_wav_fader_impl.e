note
	description: "Summary description for {EL_WAV_FADER_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-11-14 15:53:24 GMT (Thursday 14th November 2013)"
	revision: "3"

class
	EL_WAV_FADER_IMPL

inherit
	EL_COMMAND_IMPL

create
	make

feature -- Access

	Template: STRING = "[
		sox -V1 "$input_file_path" "$output_file_path" fade t $fade_in $duration $fade_out
	]"

end
