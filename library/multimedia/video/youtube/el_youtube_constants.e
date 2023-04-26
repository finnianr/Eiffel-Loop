note
	description: "Youtube variable names"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-25 13:05:31 GMT (Tuesday 25th April 2023)"
	revision: "8"

deferred class
	EL_YOUTUBE_CONSTANTS

inherit
	EL_ANY_SHARED

	EL_MODULE_TUPLE

feature {NONE} -- Constants

	Audio_type: STRING = "audio"

	Video_type: STRING = "video"

	MP4_extension: STRING = "mp4"

feature {NONE} -- Variable names

	Var: TUPLE [audio_path, format, output_path, socket_path, title, url, video_path: STRING]
		once
			create Result
			Tuple.fill (Result, "audio_path, format, output_path, socket_path, title, url, video_path")
		end

end