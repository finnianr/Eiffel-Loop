note
	description: "[
		Cache HTTP GET content under standard cache directory defined by
		${EL_STANDARD_DIRECTORY_I}.App_cache
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-10-15 10:40:22 GMT (Wednesday 15th October 2025)"
	revision: "9"

class
	EL_CACHED_HTTP_FILE

inherit
	EL_PLAIN_TEXT_FILE
		rename
			make as make_latin_1_path
		export
			{NONE}
			make_create_read_write, make_encodeable, make_open_append, make_open_read_append,
			make_open_read_write, make_open_write, make_with_name, make_with_path,
			open_read_append, open_read_write, open_write,

			put, put_boolean, put_character_32, put_character_8, put_double, put_indent,
			put_indented_line, put_indented_lines, put_integer, put_integer_16, put_integer_32,
			put_integer_64, put_integer_8, put_latin_1, put_line, put_lines, put_managed_pointer,
			put_natural, put_natural_8, put_natural_16, put_natural_32, put_natural_64,
			put_new_line, put_pointer, put_encoded_character_8, put_encoded_string_8, put_real, put_string,
			put_string_32, put_string_8, put_string_general, putbool, putchar, putdouble, putint,
			putreal, putstring
		end

	EL_MODULE_DIRECTORY; EL_MODULE_FILE; EL_MODULE_WEB

create
	make

feature {NONE} -- Initialization

	make (a_url: READABLE_STRING_GENERAL; refresh_period_hours: REAL)
		local
			part_list: EL_ZSTRING_LIST; part: ZSTRING
			url_path: FILE_PATH
		do
			url := a_url
			create part_list.make_adjusted_split (a_url, '/', 0)
			if attached part_list as list then
				from list.start until list.after loop
					part := list.item
					if list.isfirst then
						part.prune_all_trailing (':')
					end
					if part.is_empty or else part.is_character (':') then
						list.remove
					else
						list.forth
					end
				end
				url_path := Directory.App_cache + list.joined ('/')
				make_with_name (url_path)
			end
			refresh_period_secs := (refresh_period_hours * 3600).rounded
			if not url_path.exists or else has_expired then
				force_refresh
			end
		end

feature -- Access

	url: READABLE_STRING_GENERAL

feature -- Measurement

	refresh_period_secs: INTEGER

feature -- Status query

	has_expired: BOOLEAN
		-- `True' if caching period has expired
		local
			time: EL_TIME_ROUTINES
		do
			Result := time.unix_now (False) - path.modification_time > refresh_period_secs
		end

feature -- Basic operations

	refresh
		do
			if has_expired then
				force_refresh
			end
		end

	force_refresh
		do
			Web.open (url)
			Web.download (path)
			Web.close
		end
end