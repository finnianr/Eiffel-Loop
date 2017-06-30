note
	description: "[
		Minimal console only log accessed by the `lio' object in class [$source EL_MODULE_LIO]
		It is effectively just an extension of the standard `io' object. It can be optionally integrated with
		the Eiffel-Loop logging system.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-29 8:49:54 GMT (Thursday 29th June 2017)"
	revision: "5"

class
	EL_CONSOLE_ONLY_LOG

inherit
	EL_LOGGABLE

	EL_MODULE_CONSOLE

create
	make

feature {NONE} -- Initialization

	make
		do
			create {EL_CONSOLE_ROUTINE_LOG} log_sink.make (new_output)
		end

feature -- Status

	current_routine_is_active: BOOLEAN
			-- For use in routines that did not call enter to
			-- push routine on to call stack
		do
		end

feature -- Input

	pause_for_enter_key
		do
		end

feature -- Output

	enter (routine_name: STRING )
			-- Enter start of routine
		do
		end

	enter_with_args (routine_name: STRING; arg_objects: ARRAY [ANY])
			--
		do
		end

	enter_no_header (routine_name: STRING)
			--
		do
		end

	exit_no_trailer
		do
		end

	exit
		do
		end

	put_configuration_info (log_filters: ARRAYED_LIST [EL_LOG_FILTER])
		do
		end

	put_labeled_string (label, str: READABLE_STRING_GENERAL)
			--
		do
			log_sink.put_labeled_string (label, str)
		end

	put_labeled_substitution (label, template: READABLE_STRING_GENERAL; inserts: TUPLE)
		do
			log_sink.put_labeled_substitution (label, template, inserts)
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
			l_name: ZSTRING; empty_label: BOOLEAN
		do
			create l_name.make_from_general (label)
			if l_name.is_empty then
				empty_label := True
			else
				l_name.append_character (' ')
			end
			if attached {EL_FILE_PATH} a_path then
				l_name.append (English_word_file)
			else
				l_name.append (English_word_directory)
			end
			if empty_label then
				l_name.to_proper_case
			end
			put_string_field (l_name, a_path.to_string)
		end

	put_string_field_to_max_length (label, field_value: READABLE_STRING_GENERAL; max_length: INTEGER)
			-- Put string to log file edited to fit into max_length
		do
			log_sink.put_string_field_to_max_length (label, field_value, max_length)
		end

	put_substitution (template: READABLE_STRING_GENERAL; inserts: TUPLE)
		do
			log_sink.put_substitution (template, inserts)
		end

feature -- Numeric output

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

feature {EL_CONSOLE_ONLY_LOG, EL_MODULE_LIO} -- Element change

	restore (previous_stack_count: INTEGER)
			--
		do
		end

	set_logged_object (current_logged_object: ANY)
			--
		do
		end

	set_timer
			-- Set routine timer to now
		do
			log_sink.set_timer
		end

feature {NONE} -- Implementation

	new_output: EL_CONSOLE_LOG_OUTPUT
		do
			if Console.is_highlighting_enabled then
				create {EL_HIGHLIGHTED_CONSOLE_LOG_OUTPUT} Result.make
			else
				create Result.make
			end
		end

	log_sink: EL_LOGGABLE

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
