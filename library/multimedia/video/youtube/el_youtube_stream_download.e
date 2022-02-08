note
	description: "Youtube stream download command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-08 9:56:45 GMT (Tuesday 8th February 2022)"
	revision: "5"

class
	EL_YOUTUBE_STREAM_DOWNLOAD

inherit
	EL_COMMAND

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LIO

	EL_YOUTUBE_CONSTANTS

create
	make, make_default

feature {NONE} -- Initialization

	make (a_stream: EL_YOUTUBE_STREAM; output_dir: DIR_PATH; title: ZSTRING)
		require
			output_dir_exits: output_dir.exists
		local
			base_name: ZSTRING
		do
			stream := a_stream
			base_name := title.as_lower
			base_name.replace_character (' ', '-')
			file_path := output_dir + base_name
			file_path.add_extension (a_stream.type)
			file_path.add_extension (a_stream.extension)
		end

	make_default
		do
			stream := Default_stream
			create file_path
		end

feature -- Access

	file_path: FILE_PATH

	stream: EL_YOUTUBE_STREAM

feature -- Status query

	exists: BOOLEAN
		do
			Result := file_path.exists
		end

	is_default: BOOLEAN
		do
			Result := stream = Default_stream
		end

feature -- Basic operations

	execute
		do
			if stream = Default_stream then
				lio.put_line ("No valid stream")
			else
				lio.put_substitution ("Downloading %S for %S", [stream.type, stream.url])
				Cmd_download.put_path (Var_output_path, file_path)
				Cmd_download.put_natural (Var_format, stream.code)
				Cmd_download.put_string (Var_url, stream.url)
				Cmd_download.execute
				lio.put_new_line
			end
		end

	remove
		do
			if file_path.exists then
				File_system.remove_file (file_path)
			end
		end

feature {NONE} -- Constants

	Default_stream: EL_YOUTUBE_STREAM
		once
			create Result.make_default
		end

	Cmd_download: EL_OS_COMMAND
		once
			create Result.make_with_name ("youtube_download", "youtube-dl -f $format -o $output_path $url")
		end

end