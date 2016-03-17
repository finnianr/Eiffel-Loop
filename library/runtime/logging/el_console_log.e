note
	description: "[
		Minimal console only log responding only to requests from 'log_or_io' object.
		This minimal logging is always active even when logging is turned off.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:04:52 GMT (Wednesday 16th December 2015)"
	revision: "5"

class
	EL_CONSOLE_LOG

inherit
	EL_LOG
		redefine
			set_timer,

			put_labeled_string, put_string, put_line, put_new_line, put_elapsed_time,
			put_integer, put_character, put_real, put_boolean, put_double,

			put_string_field, put_path_field, put_integer_field, put_integer_interval_field,
			put_real_field, put_string_field_to_max_length, put_double_field
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			create {EL_CONSOLE_ROUTINE_LOG} log_sink.make
		end

feature {EL_CONSOLE_LOG, EL_MODULE_LOG} -- Element change

	set_timer
			-- Set routine timer to now
		do
			log_sink.set_timer
		end

feature -- Output

	put_labeled_string (label, str: READABLE_STRING_GENERAL)
			--
		do
			log_sink.put_labeled_string (label, str)
		end

	put_string (s: READABLE_STRING_GENERAL)
			--
		do
			log_sink.put_string (s)
		end

	put_line (l: READABLE_STRING_GENERAL)
			-- put string with new line
		do
			log_sink.put_line (l)
		end

	put_integer (i: INTEGER)
			--
		do
			log_sink.put_integer (i)
		end

	put_character (c: CHARACTER)
			--
		do
			log_sink.put_character (c)
		end

	put_real (r: REAL)
			--
		do
			log_sink.put_real (r)
		end

	put_boolean (b: BOOLEAN)
			--
		do
			log_sink.put_boolean (b)
		end

	put_double (d: DOUBLE)
			--
		do
			log_sink.put_double (d)
		end

	put_string_field (label, field_value: READABLE_STRING_GENERAL)
			--
		do
			log_sink.put_string_field (label, field_value)
		end

	put_path_field (label: READABLE_STRING_GENERAL; a_path: EL_PATH)
			--
		local
			l_name: ZSTRING
		do
			create l_name.make_from_unicode (label)
			l_name.append_character (' ')
			if attached {EL_FILE_PATH} a_path then
				l_name.append (English_word_file)
			else
				l_name.append (English_word_directory)
			end
			put_string_field (l_name, a_path.to_string)
		end

	put_string_field_to_max_length (label, field_value: READABLE_STRING_GENERAL; max_length: INTEGER)
			-- Put string to log file edited to fit into max_length
		do
			log_sink.put_string_field_to_max_length (label, field_value, max_length)
		end

	put_integer_field (label: READABLE_STRING_GENERAL; field_value: INTEGER)
			--
		do
			log_sink.put_integer_field (label, field_value)
		end

	put_integer_interval_field (label: READABLE_STRING_GENERAL; field_value: INTEGER_INTERVAL)
			--
		do
			log_sink.put_integer_interval_field (label, field_value)
		end


	put_real_field (label: READABLE_STRING_GENERAL; field_value: REAL)
			--
		do
			log_sink.put_real_field (label, field_value)
		end

	put_double_field (label: READABLE_STRING_GENERAL; field_value: DOUBLE)
			--
		do
			log_sink.put_double_field (label, field_value)
		end

	put_new_line
			--
		do
			log_sink.put_new_line
		end

	put_elapsed_time
			-- Log time elapsed since set_timer called
		do
			log_sink.put_elapsed_time
		end

feature {NONE} -- Implementation

	log_sink: EL_LOG

feature {NONE} -- Constants

	English_word_file: ZSTRING
		once
			Result := "file"
		end

	English_word_directory: ZSTRING
		once
			Result := "directory"
		end

end
