note
	description: "[
		Sub-appliction to download and merge selected audio and video streams from a Youtube video.
		See [$source YOUTUBE_HD_DOWNLOAD_COMMAND] for details
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-08-20 10:31:23 GMT (Monday 20th August 2018)"
	revision: "3"

class
	YOUTUBE_HD_DOWNLOAD_APP

inherit
	EL_LOGGED_COMMAND_LINE_SUB_APPLICATION [YOUTUBE_HD_DOWNLOAD_COMMAND]
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
		do
			Result := << optional_argument ("url", "youtube url") >>
		end

	default_make: PROCEDURE
		do
			Result := agent {like command}.make ("")
		end

feature {NONE} -- Constants

	Option_name: STRING = "youtube_dl"

	Description: STRING = "Download selected video and audio stream from youtube video and merge to container"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{like Current}, All_routines],
				[{YOUTUBE_HD_DOWNLOAD_COMMAND}, All_routines]
			>>
		end

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
