note
	description: "Youtube variable names"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-08-19 18:59:05 GMT (Sunday 19th August 2018)"
	revision: "1"

class
	YOUTUBE_VARIABLE_NAMES

feature {NONE} -- Constants

	MP4_extension: ZSTRING
		once
			Result := "mp4"
		end

	Var_audio_path: ZSTRING
		once
			Result := "audio_path"
		end

	Var_format: ZSTRING
		once
			Result := "format"
		end

	Var_output_path: ZSTRING
		once
			Result := "output_path"
		end

	Var_socket_path: ZSTRING
		once
			Result := "socket_path"
		end

	Var_title: ZSTRING
		once
			Result := "title"
		end

	Var_url: ZSTRING
		once
			Result := "url"
		end

	Var_video_path: ZSTRING
		once
			Result := "video_path"
		end


end
