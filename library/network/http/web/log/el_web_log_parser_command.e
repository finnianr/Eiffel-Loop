note
	description: "Web log parser command"
	descendants: "[
			EL_WEB_LOG_PARSER_COMMAND*
				${EL_TRAFFIC_ANALYSIS_COMMAND*}
					${EL_404_STATUS_ANALYSIS_COMMAND}
						${EL_REQUEST_COUNT_404_ANALYSIS_COMMAND}
						${EL_GEOGRAPHIC_404_ANALYSIS_COMMAND}
						${EL_USER_AGENT_404_ANALYSIS_COMMAND}
					${EL_GEOGRAPHIC_ANALYSIS_COMMAND}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-28 13:33:18 GMT (Tuesday 28th January 2025)"
	revision: "15"

deferred class
	EL_WEB_LOG_PARSER_COMMAND

inherit
	EL_COMMAND

	EL_MODULE_DIRECTORY; EL_MODULE_GEOLOCATION; EL_MODULE_IP_ADDRESS

	EL_MODULE_LIO; EL_MODULE_TRACK; EL_MODULE_USER_INPUT

	EL_SHARED_DATA_TRANSFER_PROGRESS_LISTENER

feature {NONE} -- Initialization

	make_default
		do
			create log_path
			create not_found_list.make (0)
			create invalid_line_list.make (0)
			Geolocation.try_restore (geolocation_data_dir)
		end

feature -- Access

	log_path: FILE_PATH

feature -- Element change

	set_log_path (a_log_path: FILE_PATH)
		do
			log_path := a_log_path
		end

feature -- Basic operations

	execute
		require else
			log_path_exists: log_path.exists
		local
			file: PLAIN_TEXT_FILE
		do
			default_entry.reset_cache
			lio.put_labeled_string ("Reading log entries", log_path.base)
			lio.put_new_line

			create file.make_open_read (log_path)
			Track.data_transfer (Console_display, file.count, agent do_with_file (file))

			lio.put_new_line
			lio.put_line ("Storing geolocation data")
			Geolocation.store (geolocation_data_dir)
			lio.put_new_line

			if invalid_line_list.count > 0 then
				lio.put_integer_field ("INVALID LOG LINES", invalid_line_list.count)
				lio.put_new_line
				lio.put_line ("(Do not contain exactly 6 double quotes)")
				across invalid_line_list as list loop
					lio.put_line (list.item)
				end
				User_input.press_enter
				lio.put_new_line
			end

			lio.put_line ("LOG LINE COUNTS")
			lio.put_integer_field ("Selected", selected_count)
			if ignored_count > 0 then
				lio.put_integer_field (" Ignored", ignored_count)
			end
			lio.put_new_line_x2
		end

feature {NONE} -- Implementation

	default_entry: EL_WEB_LOG_ENTRY
		do
			create Result.make_default
		end

	do_with (entry: like new_web_log_entry)
		deferred
		end

	do_with_file (file: PLAIN_TEXT_FILE)
		local
			done: BOOLEAN; quote_count, start_index, end_index, i: INTEGER
			s: EL_STRING_8_ROUTINES
		do
			from until done loop
				file.read_line
				if file.end_of_file then
					done := True

				elseif attached file.last_string as line then
					quote_count := line.occurrences ('%"')
					if quote_count > 6 then
					-- EXAMPLE: 47.76.72.62 - - [21/Jan/2025:13:40:40 +0000]
					--	"GET /index.php?lang=../usr/pearcmd&+config+/&/<?echo(md5("hi"));?>+/tmp/index1.php HTTP/1.1"
					--	404 530 "-" "Custom-AsyncHttpClient"

					-- Replace excess quotes with single quotes, for example replace "hi" with 'hi'.
						end_index := line.count
						from i := 0 until i = 4 or end_index = 0 loop
							end_index := line.last_index_of ('"', end_index - 1)
							i := i + 1
						end
						start_index := line.index_of ('"', 1)
						if (i = 4 and start_index > 0 and start_index <= end_index)
							and then attached line.substring (start_index + 1, end_index - 1) as substring
						then
							s.replace_character (substring, '"', '%'')
							line.replace_substring (substring, start_index + 1, end_index - 1)
						end
						quote_count := line.occurrences ('%"')
					end
					if quote_count /= 6 then
						invalid_line_list.extend (line.twin)

					elseif is_selected (line) then
						do_with (new_web_log_entry (line))
						selected_count := selected_count + 1
					else
						ignored_count := ignored_count + 1
					end
					progress_listener.on_notify (line.count + 1)
				end
			end
			file.close
			progress_listener.finish
		end

	geolocation_data_dir: DIR_PATH
		do
			Result := Directory.Sub_app_data #+ generator.as_lower
		end

	index_of_request_uri (line: STRING): INTEGER
		do
			Result := line.index_of (']', 1)
			if Result > 0 and then Result + 2 < line.count and then line [Result + 2] = '"' then
				Result := line.index_of (' ', Result + 3)
				if Result > 0 then
					Result := Result + 1
				end
			end
		end

	is_selected (line: STRING): BOOLEAN
		-- when `True' line is included for call to `do_with'
		do
			Result := True
		end

	new_web_log_entry (line: ZSTRING): EL_WEB_LOG_ENTRY
		do
			create Result.make (line)
		end

feature {NONE} -- Internal attributes

	not_found_list: EL_ARRAYED_LIST [EL_WEB_LOG_ENTRY]
		-- human visitor requests that did not have 200 as status code

	invalid_line_list: EL_STRING_8_LIST
		-- lines that do not have exactly 6 double quotes

	selected_count: INTEGER

	ignored_count: INTEGER

end