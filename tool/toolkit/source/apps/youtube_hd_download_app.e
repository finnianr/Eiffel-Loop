note
	description: "[
		Sub-appliction to download a Youtube video with the highest resolution possible and merge with
		m4a soundtrack to create a MP4 file.
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-13 11:04:11 GMT (Tuesday 13th February 2018)"
	revision: "1"

class
	YOUTUBE_HD_DOWNLOAD_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [YOUTUBE_HD_DOWNLOAD_COMMAND]
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

	Description: STRING = "Download Youtube video at highest resolution possible and convert to mp4"

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

		**Frames per Second**

		Sometimes a video is available at either 60 fps or 30 fps. Generally `youtube-dl -F'
		will list the 30 fps stream first, so this is the one that is selected. This is prefered
		as a 60 fps video may take a long time to download on slower connections, and also
		the conversion to mp4 from webm format is pretty CPU intensive and will take twice as long.

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
