note
	description: "Console and file log"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-19 11:08:05 GMT (Tuesday 19th June 2018)"
	revision: "6"

class
	EL_CONSOLE_AND_FILE_LOG

inherit
	EL_CONSOLE_ONLY_LOG
		redefine
			make, traced_routine_call_stack,
			put_configuration_info, enter, enter_no_header, enter_with_args, exit, exit_no_trailer,
			pause_for_enter_key,
			restore, set_logged_object, current_routine_is_active
		end

	EL_MODULE_EIFFEL

	EL_MODULE_LOGGING

	EL_MODULE_LOG_MANAGER

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

feature {EL_CONSOLE_ONLY_LOG, EL_MODULE_LOG} -- Element change

	set_logged_object (current_logged_object: ANY)
			--
		do
			traced_object := current_logged_object
		end

	set_log_sink_for_routine (routine: EL_LOGGED_ROUTINE_INFO)
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

	put_configuration_info (log_filters: ARRAYED_LIST [EL_LOG_FILTER])
			-- Log logging configuration information
		local
			filter: EL_LOG_FILTER; l_out: like current_thread_log_file
			routine_name, class_name: STRING; i: INTEGER
		do
			l_out := current_thread_log_file

			l_out.put_label ("LOGGED ROUTINES")
			l_out.set_text_brown
			l_out.put_string_general ("(All threads)")
			l_out.set_text_default
			l_out.put_new_line
			l_out.tab_right

			from log_filters.start until log_filters.after loop
				filter := log_filters.item
				class_name := filter.class_type.name
				if filter.class_type.type_id /= - 1 then
					l_out.put_new_line
					l_out.put_keyword ("class ")
					l_out.put_classname (class_name)
					l_out.put_character (':')

					l_out.tab_right; l_out.put_new_line

					from i := 1 until i > filter.routines.count loop
						routine_name := filter.routines [i]
						if routine_name.item (1) = '*' then
							l_out.put_string ("(All routines)")

						elseif routine_name.item (1) = '-' then
							l_out.put_string (routine_name.substring (2, routine_name.count))
							l_out.put_string (" (Disabled)")

						else
							l_out.put_string (routine_name)
						end
						if i < filter.routines.count then
							l_out.put_new_line
						end
						i := i + 1
					end
					l_out.tab_left
				else
					l_out.put_label ("No such class")
					l_out.put_classname (class_name)
					l_out.put_new_line
				end
				if log_filters.index < log_filters.count then
					l_out.put_new_line
				end
				log_filters.forth
			end
			l_out.tab_left; l_out.put_new_line

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

	traced_routine_call_stack: ARRAYED_STACK [EL_LOGGED_ROUTINE_INFO]

	traced_object: ANY

	disabled_call_forward_log: EL_SILENT_LOG

	enabled_call_forward_log: EL_CONSOLE_AND_FILE_ROUTINE_LOG

feature {NONE} -- Constants

	Default_arguments: ARRAY [ANY]
		once
			create Result.make (1, 0)
		end

end








