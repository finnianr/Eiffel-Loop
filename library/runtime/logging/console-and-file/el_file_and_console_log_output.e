note
	description: "File and console log output"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-10 9:46:06 GMT (Monday 10th February 2025)"
	revision: "24"

class
	EL_FILE_AND_CONSOLE_LOG_OUTPUT

inherit
	EL_CONSOLE_LOG_OUTPUT
		rename
			make as make_output,
			new_line as new_line_character
		redefine
			write_console, flush
		end

	PLAIN_TEXT_FILE
		rename
			make as make_read,
			put_string as put_file_string,
			put_integer as put_file_integer,
			put_natural as put_file_natural,
			put_real as put_file_real,
			put_character as put_file_character,
			put_boolean as put_file_boolean,
			put_new_line as put_file_new_line,
			put_double as put_file_double,
			flush as flush_file
		export
			{NONE} all
			{EL_LOG_MANAGER} close, name, delete, wipe_out, open_write, flush_file, path
		end

	EL_STRING_GENERAL_ROUTINES

	EL_SINGLE_THREAD_ACCESS
		rename
			mutex as write_mutex
		end

	EL_SHARED_STRING_8_BUFFER_POOL; EL_SHARED_STRING_8_CURSOR

create
	make

feature -- Initialization

	make (log_path: FILE_PATH; a_thread_name: READABLE_STRING_GENERAL; a_index: INTEGER)
			-- Create file object with `fn' as file name.
		do
			make_default
			make_output
			index := a_index
			make_open_write (log_path)

			thread_name := as_zstring (a_thread_name)
			create new_line_prompt.make_from_string ("%N " + index.out + "> ")
			is_directed_to_console := index = 1
		end

feature -- Access

	index: INTEGER

	is_directed_to_console: BOOLEAN

	thread_name: ZSTRING

feature -- Basic operations

	flush
			-- Write contents of buffer to file if it is free (not locked by another thread)
			-- Return strings of type {EL_ZSTRING} to recyle pool
		do
			if write_mutex.try_lock then
--				synchronized
					Precursor
--				end
				write_mutex.unlock
			end
		end

	redirect_to_console
			-- Write log tail to console and set future log entries to be directed to console
		do
			write_log_to_console (false)
		end

	refresh_console
			-- Write entire log to console (log should already be directed to console)
		require
			is_directed_to_console: is_directed_to_console
		do
			write_log_to_console (true)
		end

	stop_console
			-- Stop out put to console
		do
			restrict_access
				is_directed_to_console := false
			end_restriction
		end

feature {NONE} -- Implementation

	write_console (str: READABLE_STRING_GENERAL)
		do
			if str.is_string_8 and then attached {STRING_8} str as str_8 and then cursor_8 (str_8).all_ascii then
			-- string is ASCII
				put_file_string (str_8)
				if is_directed_to_console then
					std_output.put_string (str_8)
				end

			elseif attached String_8_pool.borrowed_item as borrowed then
				if attached borrowed.copied_general_as_utf_8 (str) as l_utf_8 then
					put_file_string (l_utf_8)
					if is_directed_to_console then
						if Console.is_utf_8_encoded then
							std_output.put_string (l_utf_8)
						else
							Precursor (str)
						end
					end
				end
				borrowed.return
			end
		end

	write_escape_sequence (seq: STRING_8)
		do
			if is_directed_to_console then
				std_output.put_string (seq)
			end
		end

	write_log_to_console (write_entire_log: BOOLEAN)
			--
		do
			restrict_access
				Execution_environment.clear_screen

				-- 1st time
				close; open_read

				-- 2nd time is work around to bug (once should have been sufficent)
				close; open_read

				if not write_entire_log and then count > Tail_character_count then
					move (count - tail_character_count)
					next_line
				end
				from until off loop
					read_line
					std_output.put_string (last_string)
					if not off then
						std_output.put_new_line
					end
				end
				close; open_append
				is_directed_to_console := true
			end_restriction
		end

end