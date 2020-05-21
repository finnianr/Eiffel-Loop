note
	description: "Youtube variable names"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-21 16:48:15 GMT (Thursday 21st May 2020)"
	revision: "4"

deferred class
	EL_YOUTUBE_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Audio_stream: STRING = "AUDIO"

	Video_stream: STRING = "VIDEO"

	MP4_extension: ZSTRING
		once
			Result := "mp4"
		end

	Stream_predicate_table: EL_HASH_TABLE [PREDICATE [EL_YOUTUBE_STREAM], STRING]
		once
			create Result.make (<<
				[Audio_stream, agent {EL_YOUTUBE_STREAM}.is_audio],
				[Video_stream, agent {EL_YOUTUBE_STREAM}.is_video]
			>>)
		end

feature {NONE} -- Variable names

	Var_audio_path: STRING = "audio_path"

	Var_format: STRING = "format"

	Var_output_path: STRING = "output_path"

	Var_socket_path: STRING = "socket_path"

	Var_title: STRING = "title"

	Var_url: STRING = "url"

	Var_video_path: STRING = "video_path"

end
