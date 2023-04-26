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
	date: "2023-04-26 17:22:20 GMT (Wednesday 26th April 2023)"
	revision: "23"

class
	EL_YOUTUBE_VIDEO_DOWNLOADER

inherit
	EL_APPLICATION_COMMAND
		redefine
			description
		end

	EL_MODULE_LIO; EL_MODULE_USER_INPUT

	EL_ZSTRING_CONSTANTS

	EL_YOUTUBE_CONSTANTS

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_url: EL_DIR_URI_PATH; output_dir: DIR_PATH)
		local
			input: EL_USER_INPUT_VALUE [EL_DIR_URI_PATH]
		do
			if a_url.is_empty then
				create input.make_drag_and_drop
				a_url.copy (input.value)
--				cut off any http parameters
				a_url.set_base (a_url.base.substring_to ('&', default_pointer))
			end
			if a_url.base_matches ("quit", True) then
				create video.make_default
			else
				create video.make (a_url.to_string, output_dir)
			end
		end

feature -- Basic operations

	execute
		local
			output_extension: STRING; user_quit: BOOLEAN
		do
			if video.has_streams then
				video.select_downloads
				if video.downloads_selected then
					output_extension := video.get_output_extension
					if output_extension.is_empty then
						user_quit := True

					elseif attached User_input.line (Title_prompt) as title then
						lio.put_new_line
						title.adjust
						video.set_title (title)
					end
				else
					user_quit := True
				end
			else
				user_quit := True
			end
			if user_quit then
				lio.put_line ("User quit")
			else
				video.download_all (output_extension)
				lio.put_new_line
				lio.put_line ("DONE")
			end
		end

feature {NONE} -- Internal attributes

	video: EL_YOUTUBE_VIDEO

feature {NONE} -- Constants

	Description: STRING = "[
		Download selected video and audio stream from youtube video and merge to container
	]"

	Title_prompt: STRING = "Type a short title (Or press <enter> for default)"

end