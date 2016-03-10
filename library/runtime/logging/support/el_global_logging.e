note
	description: "Summary description for {EL_GLOBAL_LOGGING}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-03 10:50:58 GMT (Sunday 3rd May 2015)"
	revision: "5"

class
	EL_GLOBAL_LOGGING

inherit
	EL_MODULE_ARGS

	EL_MODULE_EIFFEL

	EL_MODULE_LOG_MANAGER

	EL_SINGLE_THREAD_ACCESS

create
	make

feature {NONE} -- Initialization

	 make
			--
		do
			make_default
			create filter_access.make

			create Log_enabled_routines.make (Routine_hash_table_size)
			create Log_enabled_classes.make (Routine_hash_table_size)

			create Routine_table.make (Routine_hash_table_size)
			create Routine_id_table.make (Routine_hash_table_size)

		end

feature {EL_CONSOLE_AND_FILE_LOG} -- Access

	loggable_routine (type_id: INTEGER; routine_name: STRING): like Type_routine_info
			--
		do
			restrict_access
			Result := routine_by_type_and_routine_id (type_id, routine_id (routine_name), routine_name)

			end_restriction
		end

feature -- Element change

	activate
			--	
		require
			no_thread_logs_created_yet: log_manager.no_thread_logs_created
		do
			restrict_access
			active := true
			Active_or_inactive_log.replace (create {EL_CONSOLE_AND_FILE_LOG}.make)
			end_restriction
		end

	deactivate
			--	
		require
			no_thread_logs_created_yet: log_manager.no_thread_logs_created
		do
			restrict_access
			active := false

			end_restriction
		end

	set_state_from_command_line_option
			-- Turn logging on if word option is present on command line
		require
			no_thread_logs_created_yet: log_manager.no_thread_logs_created
		do
			Args.set_boolean_from_word_option ({EL_LOG_COMMAND_OPTIONS}.Logging, agent activate)
		end

	set_prompt_user_on_exit (flag: BOOLEAN)
			-- If true prompts user on exit of each logged routine
		do
			restrict_access
			user_prompt_active := flag

			end_restriction
		end

	set_routines_to_log (a_log_filters: ARRAY [EL_LOG_FILTER])
			-- Set class routines to log for all threads

			-- Each array item is list of routines to log headed by the class name.
			-- Use '*' as a wildcard to log all routines for a class
			-- Disable logging for individual routines by prepending '-'
		local
			i: INTEGER
		do
			restrict_access
			from i := a_log_filters.lower until i > a_log_filters.upper loop
				set_routine_filter_for_class (a_log_filters [i])
				i := i + 1
			end
			end_restriction
		end

feature -- Status query

	is_active: BOOLEAN
			--
		do
			restrict_access
			Result := active
			end_restriction
		end

	is_user_prompt_active: BOOLEAN
			--
		do
			restrict_access
			Result := user_prompt_active

			end_restriction
		end

	logging_enabled (routine: like Type_routine_info): BOOLEAN
			-- True if logging enabled for routine
		do
			restrict_access
			Result := Log_enabled_classes.has (routine.class_type_id) or else Log_enabled_routines.has (routine.id)
			end_restriction
		end

feature {NONE} -- Implementation

	set_routine_filter_for_class (a_filter: EL_LOG_FILTER)
			--
		require
				-- If this contract fails check class names in Log_filter are valid.
				-- Generic classes must have a single space before the character '['
				-- eg: "MY_LIST [STRING]"

			routine_names_not_empty: not a_filter.routines.is_empty
		local
			routine_name: STRING
			routine: like Type_routine_info
			i, type_id: INTEGER
		do
			type_id := a_filter.type.type_id
			from i := 1 until i > a_filter.routines.count loop
				routine_name := a_filter.routines [i]

				inspect
					routine_name.item (1)

				when Disabled_routine_character then
					-- Do nothing

				when Wild_card_for_any_routine then
					Log_enabled_classes.put (type_id, type_id)

				else
					routine := routine_by_type_and_routine_id (type_id, routine_id (routine_name), routine_name)
					Log_enabled_routines.put (routine.id, routine.id)

				end
				i := i + 1
			end
		end

	routine_by_type_and_routine_id (type_id, a_routine_id: INTEGER; routine_name: STRING): like Type_routine_info
			-- Unique routine by generating type and routine id
		require
			enough_space_to_store_type_in_routine_id_key: type_id <= Max_classes
			enough_space_to_store_routine_id_in_routine_id_key: a_routine_id <= Max_routines
		local
			l_routine_id: INTEGER; class_name: STRING
		do
			l_routine_id := type_id |<< Num_bits_routine_id + a_routine_id

			Routine_table.search (l_routine_id)
			if Routine_table.found then
				Result := Routine_table.found_item
			else
				class_name := Eiffel.type_name_of_type (type_id)
				Result := [l_routine_id, type_id, routine_name, class_name]
				Routine_table.put (Result, l_routine_id)
			end
		end

	routine_id (routine_name: STRING): INTEGER
			-- Unique identifier for routine name
		do
			Routine_id_table.search (routine_name)
			if Routine_id_table.found then
				Result := Routine_id_table.found_item
			else
				Result := Routine_id_table.count + 1
				Routine_id_table.put (Result, routine_name)
			end
		end

	Log_enabled_routines: HASH_TABLE [INTEGER, INTEGER]

	Log_enabled_classes: HASH_TABLE [INTEGER, INTEGER]

	Routine_table: HASH_TABLE [like Type_routine_info, INTEGER]

	Routine_id_table: HASH_TABLE [INTEGER, STRING]

	filter_access: MUTEX

	active: BOOLEAN

	user_prompt_active: BOOLEAN

feature -- Type definitions

	Type_routine_info: TUPLE [id, class_type_id: INTEGER; name, class_name: STRING]
		once
		end

feature -- Constants

	Max_classes: INTEGER
			-- Type id must fit into (32 - Num_bits_routine_id) bits
			-- (Assuming INTEGER is 32 bits)
		once
			Result := (1 |<< (32 - Num_bits_routine_id)) - 1
		end

	Max_routines: INTEGER
			-- Routine name id must fit into Num_bits_routine_id bits
			-- (Assuming INTEGER is 32 bits)
		once
			Result := (1 |<< Num_bits_routine_id) - 1
		end

	Num_bits_routine_id: INTEGER = 18
			-- Number of bits to store routine name id
			-- (18 is enough for over 260,000 routine name ids and over 16000 class ids)

	Wild_card_for_any_routine: CHARACTER = '*'

	Disabled_routine_character: CHARACTER = '-'

	Routine_hash_table_size: INTEGER = 53

end
