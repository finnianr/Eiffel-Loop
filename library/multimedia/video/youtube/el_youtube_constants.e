note
	description: "Youtube variable names"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-23 17:50:45 GMT (Sunday 23rd April 2023)"
	revision: "6"

deferred class
	EL_YOUTUBE_CONSTANTS

inherit
	EL_ANY_SHARED

	EL_MODULE_TUPLE

feature {NONE} -- Constants

	Audio_only: STRING = "audio only"

	Video_only: STRING = "video only"

	MP4_extension: ZSTRING
		once
			Result := "mp4"
		end

feature {NONE} -- Variable names

	Var: TUPLE [audio_path, format, output_path, socket_path, title, url, video_path: STRING]
		once
			create Result
			Tuple.fill (Result, "audio_path, format, output_path, socket_path, title, url, video_path")
		end

end