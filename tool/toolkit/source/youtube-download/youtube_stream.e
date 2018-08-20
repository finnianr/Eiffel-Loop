note
	description: "Youtube stream channel info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-08-20 10:19:55 GMT (Monday 20th August 2018)"
	revision: "3"

class
	YOUTUBE_STREAM

inherit
	EL_MODULE_LIO

	EL_STRING_CONSTANTS

	YOUTUBE_VARIABLE_NAMES

	EL_MODULE_FILE_SYSTEM

create
	make, make_default

feature {NONE} -- Initialization

	make (a_video: YOUTUBE_VIDEO; info_line: ZSTRING)
		local
			parts: EL_SPLIT_ZSTRING_LIST; base_name: ZSTRING
		do
			make_default
			url := a_video.url
			description := info_line
			create parts.make (info_line.as_canonically_spaced, Space_string)
			parts.start
			if parts.item.is_integer then
				from until parts.after loop
					inspect parts.index
						when 1 then
							code := parts.item.to_natural
						when 2 then
							extension := parts.item.twin
						when 3 then
							if parts.item ~ Audio then
								type := Audio
							elseif parts.item.has ('x') then
								resolution_x_y := parts.item.twin
								resolution_x := resolution_x_y.split ('x').first.to_integer
							end
					else
						if parts.item ~ Video then
							type := Video
						end
					end
					parts.forth
				end
			end
			base_name := a_video.title.as_lower
			base_name.replace_character (' ', '-')
			download_path := Output_dir + base_name
			download_path.add_extension (type)
			download_path.add_extension (extension)
		end

	make_default
		do
			url := Empty_string
			type := Empty_string
			extension := Empty_string
			resolution_x_y := Empty_string
			description := Empty_string
			create download_path
		end

feature -- Access

	code: NATURAL

	description: ZSTRING

	download_path: EL_FILE_PATH

	extension: ZSTRING

	resolution_x: INTEGER

	resolution_x_y: ZSTRING

	type: ZSTRING

	url: ZSTRING

feature -- Status query

	is_audio: BOOLEAN
		do
			Result := type = Audio
		end

	is_video: BOOLEAN
		do
			Result := type = Video
		end

feature -- Basic operations

	download
		do
			lio.put_substitution ("Downloading %S for %S", [type, url])
			Cmd_download.put_file_path (Var_output_path, download_path)
			Cmd_download.put_natural (Var_format, code)
			Cmd_download.put_string (Var_url, url)
			Cmd_download.execute
			lio.put_new_line
		end

	remove
		do
			if download_path.exists then
				File_system.remove_file (download_path)
			end
		end

feature {NONE} -- Constants

	Audio: ZSTRING
		once
			Result := "audio"
		end

	Cmd_download: EL_OS_COMMAND
		once
			create Result.make_with_name ("youtube_download", "youtube-dl -f $format -o $output_path $url")
		end

	Video: ZSTRING
		once
			Result := "video"
		end

	Output_dir: EL_DIR_PATH
		once
			Result := "$HOME/Videos"
			Result.expand
		end

end
