note
	description: "Youtube variable names"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-31 12:29:39 GMT (Wednesday 31st October 2018)"
	revision: "2"

class
	EL_YOUTUBE_VARIABLE_NAMES

feature {NONE} -- Constants

	MP4_extension: ZSTRING
		once
			Result := "mp4"
		end

	Var_audio_path: STRING = "audio_path"

	Var_format: STRING = "format"

	Var_output_path: STRING = "output_path"

	Var_socket_path: STRING = "socket_path"

	Var_title: STRING = "title"

	Var_url: STRING = "url"

	Var_video_path: STRING = "video_path"

end
