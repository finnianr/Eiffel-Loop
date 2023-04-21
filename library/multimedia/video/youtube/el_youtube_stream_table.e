note
	description: "Table of [$source EL_YOUTUBE_STREAM] indexed by stream code"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-21 15:42:39 GMT (Friday 21st April 2023)"
	revision: "4"

class
	EL_YOUTUBE_STREAM_TABLE

inherit
	HASH_TABLE [EL_YOUTUBE_STREAM, NATURAL]
		rename
			make as make_size
		redefine
			item, at
		end

	EL_MODULE_LIO

	EL_YOUTUBE_CONSTANTS

create
	make, make_all, make_size

feature {NONE} -- Initialization

	make_all (a_url: ZSTRING)
		do
			make (a_url, 1000)
		end

	make (a_url: ZSTRING; maximum_video_count: INTEGER)
		require
			not_empty: not a_url.is_empty
		local
			stream: EL_YOUTUBE_STREAM; video_map: EL_ARRAYED_MAP_LIST [INTEGER, EL_YOUTUBE_STREAM]
		do
			make_size (17)
			lio.put_labeled_string ("Fetching formats for", a_url)
			lio.put_new_line
			Cmd_get_youtube_options.put_string (Var_url, a_url)
			Cmd_get_youtube_options.execute

			create video_map.make (20)
			across Cmd_get_youtube_options.lines as line loop
				create stream.make (a_url, line.item)
				-- Filter out low resolution videos
				if stream.is_audio then
					extend (stream, stream.code)
				elseif stream.is_video then
					video_map.extend (stream.resolution_x, stream)
				end
			end
			video_map.sort_by_key (False)
			from video_map.start until video_map.after or else video_map.index > maximum_video_count loop
				extend (video_map.item_value, video_map.item_value.code)
				video_map.forth
			end
		end

feature -- Access

	item alias "[]", at alias "@" (code: NATURAL): EL_YOUTUBE_STREAM assign force
		do
			if has_key (code) then
				Result := found_item
			else
				create Result.make_default
			end
		end

feature {NONE} -- Constants

	Cmd_get_youtube_options: EL_CAPTURED_OS_COMMAND
		once
			create Result.make_with_name ("get_youtube_options", "youtube-dl -F $url")
		end

end