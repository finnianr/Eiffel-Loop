note
	description: "Summary description for {EL_MP3_CLIP_SAVER_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-16 22:50:06 GMT (Sunday 16th June 2013)"
	revision: "2"

class
	EL_VIDEO_TO_MP3_COMMAND_IMPL

inherit
	EL_WAV_TO_MP3_IMPL
		redefine
			template
		end

feature -- Access

	template: STRING = "[
		avconv -i "$input_file_path"
		#if $has_offset_time then
			-ss $offset_time
		#end
		#if $has_duration then
			-t ${duration}
		#end
		-f wav - | lame --id3v2-only --tt "Title" -h -b ${bit_rate} - "$output_file_path"
	]"

	-- Piping of wav output is used instead of -acode libmp3lame to prevent a problem of incorrect durations
	-- being reported in some media players (Neutron MP)
	
	-- A ID3 2.3 title is added to ensure a skelton ID3 header is in place.
	
end
