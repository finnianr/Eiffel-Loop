note
	description: "[
		Sub-appliction to download and merge selected audio and video streams from a Youtube video.
		See [$source EL_YOUTUBE_VIDEO_DOWNLOADER] for details
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-10 12:27:32 GMT (Thursday 10th September 2020)"
	revision: "11"

class
	YOUTUBE_VIDEO_DOWNLOADER_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [EL_YOUTUBE_VIDEO_DOWNLOADER]
		redefine
			Option_name, is_valid_platform
		end

create
	make

feature -- Status query

	is_valid_platform: BOOLEAN
		do
			Result := {PLATFORM}.is_unix
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := << optional_argument ("url", "youtube url") >>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {EL_INPUT_PATH [EL_DIR_URI_PATH]})
		end

feature {NONE} -- Constants

	Option_name: STRING = "youtube_dl"

	Description: STRING = "Download selected video and audio stream from youtube video and merge to container"

note
	notes: "[
		**Usage**

			el_toolkit -youtube_dl [-url <URL>]

		If you do not use the `-url' option, you will be prompted to drag and drop a url from
		a browser youtube search listing.

		**Requirements**

		Utilities `youtube-dl' and `ffmpeg' must be installed.

		**Desktop Launcher**
		Here is a suggested configuration for a XDG desktop launcher

			[Desktop Entry]
			Comment=
			Terminal=false
			Name=Youtube HD
			Exec=gnome-terminal --command="el_toolkit -youtube_dl -ask_user_to_quit" --geometry 140x50+100+100 --title="Youtube Download"
			Type=Application
			Icon=/home/<user name>/Graphics/icons/youtube-512x512.png
	]"

end
