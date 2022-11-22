note
	description: "[
		Cache HTTP GET content under standard cache directory defined by [$source EL_STANDARD_DIRECTORY_I].**App_cache**
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-22 14:38:37 GMT (Tuesday 22nd November 2022)"
	revision: "1"

class
	EL_CACHED_HTTP_FILE

inherit
	EL_PLAIN_TEXT_FILE
		rename
			make as make_latin_1_path
		export
			{NONE} all
			{ANY} close, count, delete, lines,
				read_character, read_integer, read_line_8, read_line, read_line_thread_aware,
				read_stream, read_stream_thread_aware, read_to_managed_pointer, read_to_string
		end

	EL_MODULE_DIRECTORY; EL_MODULE_FILE; EL_MODULE_WEB; EL_MODULE_TIME

create
	make

feature {NONE} -- Initialization

	make (url: READABLE_STRING_GENERAL; refresh_period_hours: REAL)
		local
			part_list: EL_ZSTRING_LIST; part: ZSTRING; s: EL_ZSTRING_ROUTINES
			url_path: FILE_PATH
		do
			create part_list.make_adjusted_split (url, '/', 0)
			if attached part_list as list then
				from list.start until list.after loop
					part := list.item
					if list.isfirst then
						part.prune_all_trailing (':')
					end
					if part.is_empty or else part.same_string_general (s.character_string (':')) then
						list.remove
					else
						list.forth
					end
				end
				url_path := Directory.App_cache + list.joined ('/')
			end
			refresh_period_secs := (refresh_period_hours * 3600).rounded
			if not url_path.exists or else Time.unix_now - url_path.modification_time > refresh_period_secs then
				Web.open (url)
				Web.download (url_path)
				Web.close
				make_open_read (url_path)
			else
				make_open_read (url_path)
			end
		end

feature -- Measurement

	refresh_period_secs: INTEGER
end