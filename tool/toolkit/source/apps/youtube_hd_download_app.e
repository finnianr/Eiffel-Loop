note
	description: "[
		Sub-appliction to download a Youtube video with the highest resolution possible and merge with
		m4a soundtrack to create a MP4 file.
	]"
	notes: "[
		**Usage**
		
			el_toolkit -youtube_dl [-url <URL>]
			
		If you do not use the `-url' option, you will be prompted to drag and drop a url from
		a browser youtube search listing.

		**Requirements**
		
		Utilities `youtube-dl' and `ffmpeg' must be installed.
		
		** Frames per Second **
		
		Sometimes a video is available at either 60 fps or 30 fps. Generally `youtube-dl -F'
		will list the 30 fps stream first, so this is the one that is selected. This is prefered
		as a 60 fps video may take a long time to download on slower connections, and also
		the conversion to mp4 from webm format is pretty CPU intensive and will take twice as long.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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

end
