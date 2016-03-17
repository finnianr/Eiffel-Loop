note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 11:47:51 GMT (Wednesday 16th December 2015)"
	revision: "5"

class
	EL_FILE_AND_CONSOLE_LOG_OUTPUT

inherit
	EL_CONSOLE_LOG_OUTPUT
		rename
			make as make_output
		redefine
			write_string, write_string_8, flush
		end

	PLAIN_TEXT_FILE
		rename
			make as make_read,
			put_string as put_file_string,
			put_integer as put_file_integer,
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

create
	make

feature -- Initialization

	make (log_path: EL_FILE_PATH; a_thread_name: STRING; a_index: INTEGER)
			-- Create file object with `fn' as file name.
		do
			make_output
			index := a_index
			make_open_write (log_path)

			thread_name := a_thread_name
			create write_mutex.make
			create new_line_prompt.make_from_string ("%N " + index.out + "> ")
			is_directed_to_console := index = 1
		end

feature -- Access

	thread_name: STRING

	is_directed_to_console: BOOLEAN

	index: INTEGER

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

	stop_console
			-- Stop out put to console
		do
			write_mutex.lock
--			synchronized
				is_directed_to_console := false
--			end
			write_mutex.unlock
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

feature {NONE} -- Implementation

	write_log_to_console (write_entire_log: BOOLEAN)
			--
		do
			write_mutex.lock
--			synchronized
				Environment.Execution.system (Clear_screen_command)

				-- 1st time
				close; open_read

				-- 2nd time is work around to bug (once should have been sufficent)
				close; open_read

				from
					if not write_entire_log and then count > Tail_character_count then
						move (count - tail_character_count)
						next_line
					end
				until
					off
				loop
					read_line
					io.put_string (last_string)
					if not off then
						io.put_new_line
					end
				end
				close; open_append
				is_directed_to_console := true
--			end
			write_mutex.unlock
		end

	write_string (str: ZSTRING)
		do
			put_file_string (str.to_utf_8)
			if is_directed_to_console.item then
				io.put_string (str.to_utf_8)
			end
		end

	write_string_8 (str_8: STRING)
		do
			if not Escape_sequences.has (str_8) then
				put_file_string (str_8)
				if is_directed_to_console.item then
					io.put_string (str_8)
				end
			end
		end

	write_mutex: MUTEX

end
