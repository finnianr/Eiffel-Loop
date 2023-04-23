note
	description: "Youtube stream download command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-23 18:07:44 GMT (Sunday 23rd April 2023)"
	revision: "7"

class
	EL_YOUTUBE_STREAM_DOWNLOAD

inherit
	EL_COMMAND

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LIO

	EL_YOUTUBE_CONSTANTS

	EL_ZSTRING_CONSTANTS

create
	make, make_default

feature {NONE} -- Initialization

	make (title, a_url: ZSTRING; a_stream: EL_YOUTUBE_STREAM; output_dir: DIR_PATH)
		require
			output_dir_exits: output_dir.exists
		local
			base_name: ZSTRING
		do
			url := a_url; stream := a_stream
			base_name := title.as_lower
			base_name.replace_character (' ', '-')
			file_path := output_dir + base_name
			file_path.add_extension (a_stream.type)
			file_path.add_extension (a_stream.extension)
		end

	make_default
		do
			url := Empty_string
			stream := Default_stream
			create file_path
		end

feature -- Access

	file_path: FILE_PATH

	stream: EL_YOUTUBE_STREAM

	url: ZSTRING

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
				lio.put_substitution ("Downloading %S for %S", [stream.type, url])
				Cmd_download.put_path (Var.output_path, file_path)
				Cmd_download.put_string (Var.format, stream.code)
				Cmd_download.put_string (Var.url, url)
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

	Default_stream: EL_YOUTUBE_VIDEO_STREAM
		once
			create Result.make_default
		end

	Cmd_download: EL_OS_COMMAND
		once
			create Result.make_with_name ("youtube_download", "youtube-dl -f $format -o $output_path $url")
		end

end