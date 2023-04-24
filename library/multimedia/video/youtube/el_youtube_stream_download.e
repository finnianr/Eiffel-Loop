note
	description: "Youtube stream download command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-24 13:26:06 GMT (Monday 24th April 2023)"
	revision: "8"

class
	EL_YOUTUBE_STREAM_DOWNLOAD

inherit
	EL_COMMAND

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LIO

	EL_YOUTUBE_CONSTANTS

	EL_ZSTRING_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_url: ZSTRING; a_stream: EL_YOUTUBE_STREAM)
		do
			url := a_url; stream := a_stream
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
feature -- Element change

	set_file_path (title: ZSTRING; output_dir: DIR_PATH)
		require
			output_dir_exits: output_dir.exists
		local
			base_name: ZSTRING
		do
			base_name := title.as_lower
			base_name.replace_character (' ', '-')
			file_path := output_dir + base_name
			file_path.add_extension (stream.type)
			file_path.add_extension (stream.extension)
		end

feature -- Basic operations

	execute
		do
			lio.put_substitution ("Downloading %S for %S", [stream.type, url])
			if attached Cmd_download as cmd then
				cmd.put_path (Var.output_path, file_path)
				cmd.put_string (Var.format, stream.code)
				cmd.put_string (Var.url, url)
				cmd.execute
			end
			lio.put_new_line
		end

	remove
		do
			if file_path.exists then
				File_system.remove_file (file_path)
			end
		end

	set_command_path (command: EL_OS_COMMAND)
		do
			if stream.type = Audio then
				command.put_path (Var.audio_path, file_path)
			else
				command.put_path (Var.video_path, file_path)
			end
		end

feature {NONE} -- Constants

	Cmd_download: EL_OS_COMMAND
		once
			create Result.make_with_name ("youtube_download", "youtube-dl -f $format -o $output_path $url")
		end

end