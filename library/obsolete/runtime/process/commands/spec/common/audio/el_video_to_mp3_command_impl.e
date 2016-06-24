note
	description: "AAC -> MP3 conversion"

	notes: "[
		Before 2015-10-21 was using piped command:
		
			-f wav - | lame --silent --id3v2-only --tt "Title" -h -b ${bit_rate} - $output_file_path
			
		This was to prevent a problem of incorrect durations being reported in some
		media players (Neutron MP). A ID3 2.3 title is added to ensure a skelton ID3 header is in place.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-18 13:43:31 GMT (Saturday 18th June 2016)"
	revision: "5"

class
	EL_VIDEO_TO_MP3_COMMAND_IMPL

inherit
	EL_WAV_TO_MP3_COMMAND_IMPL
		undefine
			template
		end

	EL_VIDEO_CONVERSION_COMMAND_IMPL

feature -- Access

	Command_arguments: STRING = "[
		-v quiet -i $input_file_path
		#if $has_offset_time then
			-ss $offset_time
		#end
		#if $has_duration then
			-t ${duration}
		#end
		-ab ${bit_rate}k -id3v2_version 4 $output_file_path
	]"

end
