note
	description: "Summary description for {EL_MP3_TO_WAV_CLIP_SAVER_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-16 18:19:27 GMT (Sunday 16th June 2013)"
	revision: "2"

class
	EL_MP3_TO_WAV_CLIP_SAVER_COMMAND_IMPL

inherit
	EL_COMMAND_IMPL

feature -- Access

	-- Note: duration has extra 0.1 secs added to prevent rounding error below the required duration

	template: STRING = "[
		avconv -i "$input_file_path" -loglevel ${log_level} -ss $offset -t ${duration}.1 "$output_file_path"
	]"
end
