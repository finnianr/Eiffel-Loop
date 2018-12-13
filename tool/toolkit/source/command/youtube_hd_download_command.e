note
	description: "[
		Command to download and merge selected audio and video streams from a Youtube video.
		
		The user is asked to select:
		
		1. an audio stream
		2. a video stream
		3. an output container type (webm or mp4 for example)
		
		If for some reason the execution is interrupted due to a network outage, it is possible to resume
		the downloads without loosing any progress by requesting a retry when prompted.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-17 13:31:28 GMT (Wednesday 17th October 2018)"
	revision: "6"

class
	YOUTUBE_HD_DOWNLOAD_COMMAND

inherit
	EL_COMMAND

	EL_MODULE_LOG

	EL_MODULE_USER_INPUT

	EL_ZSTRING_CONSTANTS

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
			output_extension: ZSTRING; done: BOOLEAN
		do
			log.enter ("execute")

			video.select_streams

			output_extension := User_input.line ("Enter an output extension")
			lio.put_new_line

			from until done loop
				video.download_streams
				if video.is_downloaded then
					if video.selected_video_stream.extension ~ output_extension then
						video.merge_streams
					elseif video.selected_video_stream.extension ~ Mp4_extension then
						video.convert_streams_to_mp4
					end
					if video.is_merge_complete then
						video.cleanup
						lio.put_new_line
						lio.put_line ("DONE")
						done := True
					else
						lio.put_string ("Merging of streams failed. Retry? (y/n)")
						done := not User_input.entered_letter ('y')
						lio.put_new_line
					end
				else
					lio.put_string ("Download of streams failed. Retry? (y/n)")
					done := not User_input.entered_letter ('y')
					lio.put_new_line
				end
			end
			log.exit
		end

feature {NONE} -- Internal attributes

	video: YOUTUBE_VIDEO

end

