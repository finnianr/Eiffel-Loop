note
	description: "Web log parser command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-26 11:01:21 GMT (Sunday 26th January 2025)"
	revision: "13"

deferred class
	EL_WEB_LOG_PARSER_COMMAND

inherit
	EL_COMMAND

	EL_MODULE_DIRECTORY; EL_MODULE_GEOLOCATION; EL_MODULE_IP_ADDRESS

	EL_MODULE_LIO; EL_MODULE_TRACK; EL_MODULE_USER_INPUT

	EL_ITERATION_OUTPUT

	EL_FILE_OPEN_ROUTINES

	EL_SHARED_PROGRESS_LISTENER

feature {NONE} -- Initialization

	make_default
		do
			create log_path
			create not_found_list.make (0)
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
			count, ignored_count: INTEGER
		do
			reset_dot_count
			default_entry.reset_cache
			if is_lio_enabled then
				lio.put_labeled_string ("Reading log entries", log_path.base)
				lio.put_new_line
			end
			if attached open_lines (log_path, Latin_1) as line_source then
				across line_source as line loop
					print_progress (line.cursor_index.to_natural_32)
					if line.shared_item.occurrences ('%"') = 6 and then is_selected (line.shared_item) then
						do_with (new_web_log_entry (line.shared_item))
						count := count + 1
					else
						ignored_count := ignored_count + 1
					end
				end
				line_source.close
			end
			if is_lio_enabled then
				lio.put_new_line
				lio.put_integer_field ("Selected entries", count)
				if ignored_count > 0 then
					lio.put_integer_field (" Ignored entries", ignored_count)
				end
				lio.put_new_line_x2
			end
		end

feature {NONE} -- Implementation

	default_entry: EL_WEB_LOG_ENTRY
		do
			create Result.make_default
		end

	do_with (entry: like new_web_log_entry)
		deferred
		end

	geolocation_data_dir: DIR_PATH
		do
			Result := Directory.Sub_app_data #+ generator.as_lower
		end

	index_of_request_uri (line: ZSTRING): INTEGER
		do
			Result := line.index_of (']', 1)
			if Result > 0 and then Result + 2 < line.count and then line [Result + 2] = '"' then
				Result := line.index_of (' ', Result + 3)
				if Result > 0 then
					Result := Result + 1
				end
			end
		end

	is_selected (line: ZSTRING): BOOLEAN
		-- when `True' line is included for call to `do_with'
		do
			Result := True
		end

	new_web_log_entry (line: ZSTRING): EL_WEB_LOG_ENTRY
		do
			create Result.make (line)
		end

	store_geolocation_data
		do
			if is_lio_enabled then
				lio.put_line ("Storing geolocation data")
			end
			Geolocation.store (geolocation_data_dir)
			if is_lio_enabled then
				lio.put_new_line_x2
			end
		end

feature {NONE} -- Internal attributes

	not_found_list: EL_ARRAYED_LIST [EL_WEB_LOG_ENTRY]
		-- human visitor requests that did not have 200 as status code

feature {NONE} -- Constants

	Iterations_per_dot: NATURAL_32
		once
			Result := 100
		end

end