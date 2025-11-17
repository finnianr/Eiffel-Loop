note
	description: "Implementation base for class ${EL_APPLICATION}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-11-17 15:51:07 GMT (Monday 17th November 2025)"
	revision: "4"

deferred class
	EL_APPLICATION_BASE

inherit
	EL_MODULE_BUILD_INFO; EL_MODULE_DIRECTORY; EL_MODULE_EXCEPTION
	EL_MODULE_FILE_SYSTEM; EL_MODULE_LIO; EL_MODULE_OS

feature -- Status query

	is_legacy_app: BOOLEAN
		-- `True' if application potentially has users with app directories in legacy locations
		-- prior to April 2020. See `{EL_STANDARD_DIRECTORY_I}.Legacy_table'
		do
			Result := False
		end

	is_switched: BOOLEAN
		-- `True' if current app is reached by a command line switch detected in class `EL_MULTI_APPLICATION_ROOT'
		-- which implies this is not the root class

	is_root_class: BOOLEAN
		do
			Result := not is_switched
		end

feature {EL_APPLICATION} -- Factory routines

	new_command_options: EL_APPLICATION_COMMAND_OPTIONS
		do
			create Result.make
		end

	new_configuration: detachable EL_APPLICATION_CONFIGURATION
		-- redefine to create configuration singleton just before `initialization' routine is called
		do
		end

	new_option_name: ZSTRING
		do
			create Result.make_from_general (option_name)
		end

feature {NONE} -- Implementation

	call (object: ANY)
			-- For initializing once routines
		do
		end

	create_app_directories
		local
			option_sub_dir, dir_path: DIR_PATH
		do
			if is_legacy_app then
				migrate_legacy_directories
			end
			create option_sub_dir.make (option_name)
			across App_directory_list as list loop
				if is_switched then
					dir_path := list.item.plus_dir (option_sub_dir)
				else
					dir_path := list.item
				end
				if not dir_path.exists then
					File_system.make_directory (dir_path)
				end
			end
		end

	migrate (legacy_dir, standard_dir: DIR_PATH)
		-- migrate legacy paths to standard
		require
			legacy_dir_exists: legacy_dir.exists
		do
			File_system.make_directory (standard_dir.parent)
			OS.move_to_directory (legacy_dir, standard_dir.parent)
			File_system.delete_if_empty (legacy_dir.parent)
		end

	migrate_legacy_directories
		do
			if attached Directory.Legacy_table as table then
				across App_directory_list as list loop
				-- If a differing legacy data directory exists already, move it to standard location
					if attached list.item as standard_dir and then table.has_key (standard_dir)
						and then attached table.found_item as legacy_dir
						and then legacy_dir.exists and then legacy_dir /~ standard_dir
					then
						migrate (legacy_dir, standard_dir)
					end
				end
			end
		end

	on_operating_system_signal
			--
		do
		end

	read_command_options
		-- read command line options
		do
		end

	return_to_quit
		do
			lio.put_new_line
			io.put_string ("<RETURN TO QUIT>")
			io.read_character
		end

	show_benchmarks (timer: EL_EXECUTION_TIMER)
		-- show execution times and average execution time since last version update
		local
			timer_data: RAW_FILE; data_version: NATURAL; i, data_count: INTEGER
			sum_elapsed_times: DOUBLE; file_path: FILE_PATH
		do
			file_path := Directory.Sub_app_data + "show_benchmarks.dat"
			timer.stop
			across (";Average ").split (';') as l_prefix loop
				lio.put_labeled_string (l_prefix.item + "Execution time", timer.elapsed_time.out)
				lio.put_new_line
				if l_prefix.is_first then
					-- Set average elapsed time from previous runs
					if file_path.exists then
						create timer_data.make_open_read (file_path)
						timer_data.read_natural
						data_version := timer_data.last_natural
						data_count := (timer_data.count - {PLATFORM}.Natural_32_bytes) // {PLATFORM}.Real_64_bytes
						from i := 1 until i > data_count loop
							timer_data.read_double
							sum_elapsed_times := sum_elapsed_times + timer_data.last_double
							i := i + 1
						end
					else
						File_system.make_directory (file_path.parent)
						create timer_data.make_open_write (file_path)
						timer_data.put_natural_32 (Build_info.version_number)
						data_version := Build_info.version_number
					end
					timer_data.close
					if Build_info.version_number > data_version then
						-- Reset file to zero items
						create timer_data.make_open_write (file_path)
						timer_data.put_natural_32 (Build_info.version_number)
						sum_elapsed_times := 0; data_count := 0
					else
						create timer_data.make_open_append (file_path)
					end
					timer_data.put_double (timer.elapsed_millisecs)
					timer_data.close
					lio.put_integer_field ("Previous runs", data_count)
					lio.put_new_line
					sum_elapsed_times := sum_elapsed_times + timer.elapsed_millisecs
					data_count := data_count + 1
					timer.set_elapsed_millisecs ((sum_elapsed_times / data_count).rounded)
				end
			end
		end

	visible_types: TUPLE
		-- types with lio output visible in console
		-- See: {EL_CONSOLE_MANAGER_I}.show_all
		do
			create Result
		end

	visible_types_list: EL_TUPLE_TYPE_LIST [EL_MODULE_LIO]
		do
			create Result.make_from_tuple (visible_types)
		ensure
			all_conform_to_EL_MODULE_LIO: Result.all_conform
		end

feature {NONE} -- Deferred

	option_name: READABLE_STRING_GENERAL
		-- command line switch option name
		deferred
		end

feature {NONE} -- Internal attributes

	internal_timer: detachable EL_EXECUTION_TIMER

feature {EL_DESKTOP_ENVIRONMENT_I} -- Constants

	App_directory_list: EL_ARRAYED_LIST [DIR_PATH]
		once
			Result := Directory.app_list
		end

	Environment_variable: EL_DEFINE_VARIABLE_COMMAND_OPTION
		-- Define an environment variable: -define name=<value>
		-- To use, add this to redefinition of `standard_options' in descendant
		once
			create Result.make
		end

end