note
	description: "Loggable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:47 GMT (Saturday 19th May 2018)"
	revision: "6"

deferred class
	EL_LOGGABLE

feature -- Status

	current_routine_is_active: BOOLEAN
			-- For use in routines that did not call enter to
			-- push routine on to call stack
		deferred
		end

feature {EL_CONSOLE_ONLY_LOG, EL_MODULE_LIO} -- Element change

	restore (previous_stack_count: INTEGER)
			--
		deferred
		end

	set_logged_object (current_logged_object: ANY)
			--
		deferred
		end

	set_timer
			-- Set routine timer to now
		deferred
		end

feature -- Query

	call_stack_count: INTEGER
			-- For use in routines that did not call enter to
			-- push routine on to call stack
		do
			Result := traced_routine_call_stack.count
		end

feature -- Status change

	tab_left
			--
		deferred
		end

	tab_right
			--
		deferred
		end

feature -- Output

	enter (routine_name: STRING )
			-- Enter start of routine
		deferred
		end

	enter_no_header (routine_name: STRING)
			--
		deferred
		end

	enter_with_args (routine_name: STRING; arg_objects: ARRAY [ANY])
			--
		deferred
		end

	exit
		deferred
		end

	exit_no_trailer
		deferred
		end

	put_boolean (b: BOOLEAN)
			--
		deferred
		end

	put_character (c: CHARACTER)
			--
		deferred
		end

	put_configuration_info (log_filters: ARRAYED_LIST [EL_LOG_FILTER])
		deferred
		end

	put_double (d: DOUBLE)
			--
		deferred
		end

	put_double_field (label: READABLE_STRING_GENERAL; field_value: DOUBLE)
			--
		deferred
		end

	put_elapsed_time
			-- Log time elapsed since set_timer called
		deferred
		end

	put_integer (i: INTEGER)
			--
		deferred
		end

	put_integer_field (label: READABLE_STRING_GENERAL; field_value: INTEGER)
			--
		deferred
		end

	put_integer_interval_field (label: READABLE_STRING_GENERAL; field_value: INTEGER_INTERVAL)
			--
		deferred
		end

	put_labeled_string (label, str: READABLE_STRING_GENERAL)
			--
		deferred
		end

	put_labeled_substitution (label, template: READABLE_STRING_GENERAL; inserts: TUPLE)
		deferred
		end

	put_line (l: READABLE_STRING_GENERAL)
			-- put string with new line
		deferred
		end

	put_new_line
			--
		deferred
		end

	put_path_field (label: READABLE_STRING_GENERAL; a_path: EL_PATH)
			--
		deferred
		end

	put_real (r: REAL)
			--
		deferred
		end

	put_real_field (label: READABLE_STRING_GENERAL; field_value: REAL)
			--
		deferred
		end

	put_string (s: READABLE_STRING_GENERAL)
			--
		deferred
		end

	put_string_field (label, field_value: READABLE_STRING_GENERAL)
			--
		deferred
		end

	put_string_field_to_max_length (label, field_value: READABLE_STRING_GENERAL; max_length: INTEGER)
			-- Put string to log file edited to fit into max_length
		deferred
		end

	put_substitution (template: READABLE_STRING_GENERAL; inserts: TUPLE)
			-- Substitute inserts into template at the '%S' markers
			-- If the tempate has a colon, then apply color highlighting as per `put_labeled_string'
		deferred
		end

feature -- Input

	pause_for_enter_key
		deferred
		end

feature {NONE} -- Implementation

	current_routine: EL_LOGGED_ROUTINE_INFO
			--
		require
			valid_logged_routine_call_stack: not traced_routine_call_stack.is_empty
		do
			Result := traced_routine_call_stack.item
		end

	traced_routine_call_stack: ARRAYED_STACK [EL_LOGGED_ROUTINE_INFO]
		do
			Result := Default_traced_routine_call_stack
		end

feature {NONE} -- Constants

	Default_traced_routine_call_stack: ARRAYED_STACK [EL_LOGGED_ROUTINE_INFO]
		once
			create Result.make (0)
		end

end
