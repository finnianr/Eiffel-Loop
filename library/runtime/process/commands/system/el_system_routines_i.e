note
	description: "System operations based on command line utilities"
	notes: "[
		If you are creating an application on Windows with a graphical UI then these commands are not suitable
		as they cause a command console to momentarily appear. This might be off-putting to some users.
		For Windows GUI apps use instead the routines accessible via [$source EL_MODULE_FILE_SYSTEM]
		
		But maybe something can be done about this by appending `>null' to the command strings or
		something.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 17:04:27 GMT (Sunday 5th November 2023)"
	revision: "4"

deferred class
	EL_SYSTEM_ROUTINES_I

inherit
	EL_OS_DEPENDENT

	EL_MODULE_DIRECTORY
		export
			{ANY} Directory
		end

	EL_MODULE_ITERABLE

	EL_STRING_8_CONSTANTS

	EL_LAZY_ATTRIBUTE
		rename
			item as cpu_info,
			new_item as new_cpu_info
		end

	EL_LAZY_ATTRIBUTE_2
		rename
			item as user_list,
			new_item as new_user_list
		end

feature -- Access

	processor_count: INTEGER
		-- number of CPU threads
		do
			Result := cpu_info.processor_count
		end

	scaled_processor_count (cpu_percentage: INTEGER): INTEGER
		do
			Result := (Processor_count * cpu_percentage / 100).rounded
		end

	user_permutation_list (user_dir_list: ITERABLE [DIR_PATH]): EL_ARRAYED_LIST [DIR_PATH]
		-- list of permutations of system users over the `user_dir_list' directory list
		require
			all_user_directories: across user_dir_list as list all Directory.home.is_parent_of (list.item) end
		local
			index: INTEGER; steps: EL_PATH_STEPS
		do
			create Result.make (user_list.count * Iterable.count (user_dir_list))
			Result.compare_objects
			index := Directory.Users.step_count
			across user_dir_list as list loop
				steps := list.item
				across user_list as user loop
					steps [index + 1] := user.item
					Result.extend (steps)
				end
			end
		ensure
			valid_count: Result.count = user_list.count * Iterable.count (user_dir_list)
		end

feature -- Constants

	CPU_model_name: STRING
			--
		once
			Result := new_cpu_model_name
			Result.replace_substring_all ("(R)", Empty_string_8)
		end

feature {NONE} -- Factory

	new_cpu_model_name: STRING
		deferred
		end

	new_cpu_info: TUPLE [processor_count: INTEGER; model_name: STRING]
		local
			info: EL_CPU_INFO_COMMAND_I
		do
			create {EL_CPU_INFO_COMMAND_IMP} info.make
			-- make calls execute
			Result := [info.processor_count, info.model_name]
		end

	new_user_list: EL_ZSTRING_LIST
		-- list of user names
		local
			info: EL_USERS_INFO_COMMAND_I
		do
			create {EL_USERS_INFO_COMMAND_IMP} info.make
			Result := info.user_list
		end

end