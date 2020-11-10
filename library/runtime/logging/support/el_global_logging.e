note
	description: "Global logging"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-09 13:43:02 GMT (Monday 9th November 2020)"
	revision: "12"

class
	EL_GLOBAL_LOGGING

inherit
	EL_SINGLE_THREAD_ACCESS

	EL_MODULE_EIFFEL

	EL_MODULE_LOG

	EL_SOLITARY
		rename
			make as make_solitary
		end

	EL_LOG_CONSTANTS

create
	make

feature {NONE} -- Initialization

	 make (active: BOOLEAN)
			--
		do
			make_solitary; make_default

			create filter_access.make

			create log_enabled_routines.make (Routine_hash_table_size)
			create log_enabled_classes.make (Routine_hash_table_size)

			create routine_table.make (Routine_hash_table_size)
			create routine_id_table.make (Routine_hash_table_size)
			is_active := active
		end

feature {EL_CONSOLE_AND_FILE_LOG} -- Access

	loggable_routine (type_id: INTEGER; routine_name: STRING): EL_LOGGED_ROUTINE_INFO
			--
		do
			restrict_access
			Result := routine_by_type_and_routine_id (type_id, routine_id (routine_name), routine_name)

			end_restriction
		end

feature -- Element change

	set_prompt_user_on_exit (flag: BOOLEAN)
			-- If true prompts user on exit of each logged routine
		do
			restrict_access
			user_prompt_active := flag

			end_restriction
		end

	set_routines_to_log (log_filters: LIST [EL_LOG_FILTER])
			-- Set class routines to log for all threads

			-- Each array item is list of routines to log headed by the class name.
			-- Use '*' as a wildcard to log all routines for a class
			-- Disable logging for individual routines by prepending '-'
		do
			restrict_access
			log_filters.do_all (agent set_routine_filter_for_class)
			end_restriction
		end

feature -- Status query

	is_active: BOOLEAN

	is_user_prompt_active: BOOLEAN
			--
		do
			restrict_access
			Result := user_prompt_active

			end_restriction
		end

	logging_enabled (routine: EL_LOGGED_ROUTINE_INFO): BOOLEAN
			-- True if logging enabled for routine
		do
			restrict_access
			Result := log_enabled_classes.has (routine.class_type_id) or else log_enabled_routines.has (routine.id)
			end_restriction
		end

feature {NONE} -- Implementation

	set_routine_filter_for_class (a_filter: EL_LOG_FILTER)
		local
			routine: EL_LOGGED_ROUTINE_INFO; type_id: INTEGER
		do
			type_id := a_filter.class_type.type_id
			inspect a_filter.type
				when Show_all then
					log_enabled_classes.put (type_id, type_id)

				when Show_none then
					do_nothing
			else
				across a_filter.routines as name loop
					routine := routine_by_type_and_routine_id (type_id, routine_id (name.item), name.item)
					log_enabled_routines.put (routine.id, routine.id)
				end
			end
		end

	routine_by_type_and_routine_id (type_id, a_routine_id: INTEGER; routine_name: STRING): EL_LOGGED_ROUTINE_INFO
			-- Unique routine by generating type and routine id
		require
			enough_space_to_store_type_in_routine_id_key: type_id <= Max_classes
			enough_space_to_store_routine_id_in_routine_id_key: a_routine_id <= Max_routines
		local
			l_routine_id: INTEGER; class_name: STRING
		do
			l_routine_id := type_id |<< Num_bits_routine_id + a_routine_id

			if routine_table.has_key (l_routine_id) then
				Result := routine_table.found_item
			else
				class_name := Eiffel.type_name_of_type (type_id)
				create Result.make (l_routine_id, type_id, routine_name, class_name)
				routine_table.put (Result, l_routine_id)
			end
		end

	routine_id (routine_name: STRING): INTEGER
			-- Unique identifier for routine name
		do
			if routine_id_table.has_key (routine_name) then
				Result := routine_id_table.found_item
			else
				Result := routine_id_table.count + 1
				routine_id_table.put (Result, routine_name)
			end
		end

	log_enabled_routines: HASH_TABLE [INTEGER, INTEGER]

	log_enabled_classes: HASH_TABLE [INTEGER, INTEGER]

	routine_table: HASH_TABLE [EL_LOGGED_ROUTINE_INFO, INTEGER]

	routine_id_table: HASH_TABLE [INTEGER, STRING]

	filter_access: MUTEX

	user_prompt_active: BOOLEAN

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

	Routine_hash_table_size: INTEGER = 53

end