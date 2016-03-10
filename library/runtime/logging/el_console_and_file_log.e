note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-03 10:50:07 GMT (Sunday 3rd May 2015)"
	revision: "5"

class
	EL_CONSOLE_AND_FILE_LOG

inherit
	EL_CONSOLE_LOG
		redefine
			make, traced_routine_call_stack,
			put_configuration_info, enter, enter_no_header, enter_with_args, exit, exit_no_trailer,
			pause_for_enter_key,
			restore, set_logged_object, current_routine_is_active
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			create traced_routine_call_stack.make (10)
			create disabled_call_forward_log
			create enabled_call_forward_log.make (traced_routine_call_stack)
			log_sink := disabled_call_forward_log
		end

feature -- Element change

	restore (previous_stack_count: INTEGER)
			-- Return call stack to original level before an exception
		require else
			valid_stack_size: is_valid_stack_size (previous_stack_count)
		do
			from until
				traced_routine_call_stack.count = previous_stack_count
			loop
				pop_call_stack
			end
			log_sink.restore (previous_stack_count)
		end

feature {EL_CONSOLE_LOG, EL_MODULE_LOG} -- Element change

	set_logged_object (current_logged_object: ANY)
			--
		do
			traced_object := current_logged_object
		end

	set_log_sink_for_routine (routine: like Logging.Type_routine_info)
			--
		do
			if logging.logging_enabled (routine) then
			    log_sink := enabled_call_forward_log
			else
			    log_sink := disabled_call_forward_log
			end
		end

feature -- Status

	current_routine_is_active: BOOLEAN
			-- For use in routines that did not call enter to
			-- push routine on to call stack
		do
			Result := log_sink.current_routine_is_active
		end

	is_valid_stack_size (previous_stack_count: INTEGER): BOOLEAN
			--
		do
			Result := call_stack_count >= previous_stack_count
		end

feature -- Output

	put_configuration_info (a_log_filters: ARRAY [EL_LOG_FILTER])
			-- Log logging configuration information
		local
			l_out: EL_FILE_AND_CONSOLE_LOG_OUTPUT
			filter: EL_LOG_FILTER
			title, routine_name, class_name: STRING
			i, j: INTEGER
		do
			l_out := log_manager.current_thread_log_file

			title := "ROUTINES LOGGED (All threads)"

			l_out.put_new_line
			l_out.put_separator
			l_out.put_string (title)
			l_out.put_new_line
			l_out.tab_right

			from i := 1 until i > a_log_filters.count loop
				filter := a_log_filters [i]
				class_name := filter.type.name
				if filter.type.type_id /= - 1 then
					l_out.put_new_line
					l_out.put_keyword ("class ")
					l_out.put_classname (class_name)
					l_out.put_character (':')

					l_out.tab_right; l_out.put_new_line

					from j := 1 until j > filter.routines.count loop
						routine_name := filter.routines [j]
						if routine_name.item (1) = '*' then
							l_out.put_string ("(All routines)")

						elseif routine_name.item (1) = '-' then
							l_out.put_string (routine_name.substring (2, routine_name.count))
							l_out.put_string (" (Disabled)")

						else
							l_out.put_string (routine_name)
						end
						if j < filter.routines.count then
							l_out.put_new_line
						end
						j := j + 1
					end
					l_out.tab_left
				else
					l_out.put_label ("No such class")
					l_out.put_classname (class_name)
					l_out.put_new_line
				end
				if i < a_log_filters.count then
					l_out.put_new_line
				end
				i := i + 1
			end
			l_out.tab_left; l_out.put_new_line; l_out.put_separator

			l_out.flush
		end

	enter (routine_name: STRING )
			-- Enter start of routine
		do
			enter_with_args (routine_name, Default_arguments)
		ensure then
			valid_call_stack: traced_routine_call_stack.count = old traced_routine_call_stack.count + 1
		end

	enter_no_header (routine_name: STRING)
			--
		do
			push_call_stack (routine_name)
		ensure then
			valid_call_stack: traced_routine_call_stack.count = old traced_routine_call_stack.count + 1
		end

	enter_with_args (routine_name: STRING; arg_objects: ARRAY [ANY])
		do
			push_call_stack (routine_name)
			log_sink.enter_with_args (routine_name, arg_objects)
		ensure then
			valid_call_stack: traced_routine_call_stack.count = old traced_routine_call_stack.count + 1
		end

	exit
			--
		do
			pause_for_enter_key
			log_sink.exit
			pop_call_stack
		ensure then
			valid_call_stack: traced_routine_call_stack.count = old traced_routine_call_stack.count - 1
		end

	exit_no_trailer
			--
		do
			pop_call_stack
		ensure then
			valid_call_stack: traced_routine_call_stack.count = old traced_routine_call_stack.count - 1
		end

feature -- Input

	pause_for_enter_key
			-- Called from routine exit
		do
			if user_prompting_on then
				log_sink.pause_for_enter_key
			end
		end

feature {NONE} -- Implementation

	user_prompting_on: BOOLEAN
			--
		do
			Result := logging.is_user_prompt_active
		end

	push_call_stack (routine_name: STRING)
			--
		local
			type_id: INTEGER
		do
			type_id := Eiffel.dynamic_type (traced_object)

			traced_routine_call_stack.extend (logging.loggable_routine (type_id, routine_name))
			set_log_sink_for_routine (current_routine)
		end

	pop_call_stack
			--
		do
			traced_routine_call_stack.remove
			if not traced_routine_call_stack.is_empty then
				set_log_sink_for_routine (current_routine)
			end
		end

	traced_routine_call_stack: ARRAYED_STACK [like Logging.type_routine_info]

	traced_object: ANY

	disabled_call_forward_log: EL_LOG

	enabled_call_forward_log: EL_CONSOLE_AND_FILE_ROUTINE_LOG

feature {NONE} -- Constants

	Default_arguments: ARRAY [ANY]
		once
			create Result.make (1, 0)
		end

end -- class EL_LOG









