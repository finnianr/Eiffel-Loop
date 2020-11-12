note
	description: "Global logging"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-12 15:49:51 GMT (Thursday 12th November 2020)"
	revision: "15"

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

			create routine_table.make (100)
			create type_table.make (50, agent Eiffel.type_of_type)
			create filter_table.make (30)
			create reusable_key.make_empty
			is_active := active
		end

feature {EL_CONSOLE_AND_FILE_LOG} -- Access

	loggable_routine (type_id: INTEGER; routine_name: STRING): EL_LOGGED_ROUTINE
			--
		do
			restrict_access
				reusable_key.set (type_id, routine_name)

				if routine_table.has_key (reusable_key) then
					Result := routine_table.found_item
				else
					create Result.make (type_table.item (type_id), routine_name)
					routine_table.extend (Result, Result)
				end
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

	logging_enabled (routine: EL_LOGGED_ROUTINE): BOOLEAN
			-- True if logging enabled for routine
		do
			restrict_access
			if filter_table.has_key (routine.type_id) then
				inspect filter_table.found_item.type
					when Show_all then
						Result := True

					when Show_selected then
						Result := filter_table.found_item.routine_set.has (routine.name)
				else
				end
			end
			end_restriction
		end

feature {NONE} -- Implementation

	set_routine_filter_for_class (a_filter: EL_LOG_FILTER)
		do
			inspect a_filter.type
				when Show_all, Show_selected then
					filter_table.put (a_filter, a_filter.class_type.type_id)
			else
			end
		end

feature {NONE} -- Internal attributes

	filter_access: MUTEX

	routine_table: HASH_TABLE [EL_LOGGED_ROUTINE, EL_LOGGED_ROUTINE]

	reusable_key: EL_LOGGED_ROUTINE
		-- reusable key

	type_table: EL_CACHE_TABLE [TYPE [ANY], INTEGER]
		-- look up from type_id

	filter_table: HASH_TABLE [EL_LOG_FILTER, INTEGER]
		-- class filter by type_id

	user_prompt_active: BOOLEAN

end