note
	description: "Console and file log"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-03 10:25:55 GMT (Saturday 3rd December 2022)"
	revision: "17"

class
	EL_CONSOLE_AND_FILE_LOG

inherit
	EL_CONSOLE_ONLY_LOG
		redefine
			make, enter, enter_no_header, enter_with_args, exit, exit_no_trailer,
			pause_for_enter_key, restore, set_logged_object, current_routine_is_active
		end

	EL_MODULE_LOGGING

	EL_MODULE_LOG_MANAGER

create
	make

feature {NONE} -- Initialization

	make
		do
			create routine_call_stack.make (10)
			create disabled_call_forward_log.make
			create enabled_call_forward_log.make (routine_call_stack)
			log_sink := disabled_call_forward_log
		end

feature -- Element change

	restore (previous_stack_count: INTEGER)
			-- Return call stack to original level before an exception
		require else
			valid_stack_size: is_valid_stack_size (previous_stack_count)
		do
			from until
				routine_call_stack.count = previous_stack_count
			loop
				pop_call_stack
			end
			log_sink.restore (previous_stack_count)
		end

feature {EL_CONSOLE_ONLY_LOG, EL_MODULE_LOG} -- Element change

	set_log_sink_for_routine (routine: EL_LOGGED_ROUTINE)
			--
		do
			if logging.logging_enabled (routine) then
			    log_sink := enabled_call_forward_log
			else
			    log_sink := disabled_call_forward_log
			end
		end

	set_logged_object (current_logged_object: ANY)
			--
		do
			traced_object := current_logged_object
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

	enter (routine_name: STRING )
			-- Enter start of routine
		do
			enter_with_args (routine_name, Default_arguments)
		ensure then
			valid_call_stack: routine_call_stack.count = old routine_call_stack.count + 1
		end

	enter_no_header (routine_name: STRING)
			--
		do
			push_call_stack (routine_name)
		ensure then
			valid_call_stack: routine_call_stack.count = old routine_call_stack.count + 1
		end

	enter_with_args (routine_name: STRING; arg_objects: TUPLE)
		do
			push_call_stack (routine_name)
			log_sink.enter_with_args (routine_name, arg_objects)
		ensure then
			valid_call_stack: routine_call_stack.count = old routine_call_stack.count + 1
		end

	exit
			--
		do
			pause_for_enter_key
			log_sink.exit
			pop_call_stack
		ensure then
			valid_call_stack: routine_call_stack.count = old routine_call_stack.count - 1
		end

	exit_no_trailer
			--
		do
			pop_call_stack
		ensure then
			valid_call_stack: routine_call_stack.count = old routine_call_stack.count - 1
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

	pop_call_stack
			--
		do
			routine_call_stack.remove
			if not routine_call_stack.is_empty then
				set_log_sink_for_routine (current_routine)
			end
		end

	push_call_stack (routine_name: STRING)
			--
		local
			routine: EL_LOGGED_ROUTINE
		do
			routine := logging.loggable_routine ({ISE_RUNTIME}.dynamic_type (traced_object), routine_name)
			routine_call_stack.extend (routine)
			set_log_sink_for_routine (current_routine)
		end

	user_prompting_on: BOOLEAN
			--
		do
			Result := logging.is_user_prompt_active
		end

feature {NONE} -- Internal attributes

	disabled_call_forward_log: EL_SILENT_LOG

	enabled_call_forward_log: EL_CONSOLE_AND_FILE_ROUTINE_LOG

	traced_object: ANY

feature {NONE} -- Constants

	Default_arguments: TUPLE
		once
			create Result
		end

end