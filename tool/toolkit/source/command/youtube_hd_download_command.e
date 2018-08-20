note
	description: "[
		Sub-appliction to download and merge selected audio and video streams from a Youtube video.
		
		The user is asked to select:
		
		1. an audio stream
		2. a video stream
		3. an output container type (webm or mp4 for example)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-08-20 10:38:32 GMT (Monday 20th August 2018)"
	revision: "4"

class
	YOUTUBE_HD_DOWNLOAD_COMMAND

inherit
	EL_COMMAND

	EL_MODULE_LOG

	EL_MODULE_USER_INPUT

	EL_STRING_CONSTANTS

	YOUTUBE_VARIABLE_NAMES

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_url: ZSTRING)
		do
			create video.make (a_url)
		end

feature -- Basic operations

	execute
		local
			output_extension: ZSTRING
		do
			log.enter ("execute")

			video.select_streams

			output_extension := User_input.line ("Enter an output extension")
			lio.put_new_line

			video.download_streams

			if video.selected_video_stream.extension ~ output_extension then
				video.merge_streams
			elseif video.selected_video_stream.extension ~ Mp4_extension then
				video.convert_streams_to_mp4
			end
			video.cleanup
			lio.put_new_line
			lio.put_line ("DONE")
			log.exit
		end

feature {NONE} -- Internal attributes

	video: YOUTUBE_VIDEO

end

