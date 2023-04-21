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
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-21 15:49:04 GMT (Friday 21st April 2023)"
	revision: "18"

class
	EL_YOUTUBE_VIDEO_DOWNLOADER

inherit
	EL_APPLICATION_COMMAND
		redefine
			description
		end

	EL_MODULE_LIO

	EL_MODULE_USER_INPUT

	EL_ZSTRING_CONSTANTS

	EL_YOUTUBE_CONSTANTS

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_url: EL_DIR_URI_PATH)
		local
			input: EL_USER_INPUT_VALUE [EL_DIR_URI_PATH]
		do
			if a_url.is_empty then
				create input.make_drag_and_drop
				a_url.copy (input.value)
			end
			if a_url.base_matches ("quit", True) then
				create video.make_default

			elseif attached User_input.line ("Enter a title") as title then
				lio.put_new_line
				create video.make (a_url.to_string, title)
			end
		end

feature -- Basic operations

	execute
		local
			output_extension: ZSTRING; done: BOOLEAN
		do
			if video.stream_count > 0 then
				video.select_downloads

				output_extension := User_input.line ("Enter an output extension")
				lio.put_new_line
			else
				done := True
			end

			from until done loop
				video.download_streams
				if video.downloads_exists then
					if video.download.video.stream.extension ~ output_extension then
						video.merge_streams
					elseif video.download.video.stream.extension ~ Mp4_extension then
						video.convert_streams_to_mp4
					end
					if video.is_merge_complete then
						video.cleanup
						lio.put_new_line
						lio.put_line ("DONE")
						done := True
					else
						done := not User_input.approved_action_y_n ("Merging of streams failed. Retry?")
					end
				else
					done := not User_input.approved_action_y_n ("Download of streams failed. Retry?")
				end
			end
		end

feature {NONE} -- Internal attributes

	video: EL_YOUTUBE_VIDEO

feature {NONE} -- Constants

	Description: STRING = "[
		Download selected video and audio stream from youtube video and merge to container
	]"

end