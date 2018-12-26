note
	description: "[
		Cluster of cross platform implementations and interfaces
		
		The `normalize_locations' procedure does the following:
		
		Any class file names ending with `_i.e' are matched with implementation classes ending with `_imp.e'.
		If only a common-platform exists then the implementation class is moved to the normalized location
		
			imp_common/<path>/<class-name>.e
			
		where `<path>' is the location relative to the cluster directory.
		
		Where Windows and Unix implementations exist then the implementation classes are moved to
		normalized locations
		
			imp_unix/<path>/<class-name>.e
			imp_mswin/<path>/<class-name>.e

		where `<path>' is the location relative to the cluster directory.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-26 14:38:44 GMT (Wednesday 26th December 2018)"
	revision: "2"

class
	CROSS_PLATFORM_CLUSTER

inherit
	CROSS_PLATFORM_CONSTANTS

	EL_MODULE_LIO

	EL_MODULE_TUPLE

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_OS

	EL_MODULE_USER_INPUT

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make

feature {NONE} -- Initialization

	make (a_cluster_dir: EL_DIR_PATH; path_list: EL_FILE_PATH_LIST; ecf: ECF_INFO)
		local
			relative_path: EL_FILE_PATH
		do
			cluster_dir := a_cluster_dir
			ecf_name := ecf.path.base
			create interface_list.make_with_count (5)
			create implementation_list.make_with_count (5)
			implementation_list.compare_objects

			across path_list as source loop
				if cluster_dir.is_parent_of (source.item) then
					relative_path := source.item.relative_path (cluster_dir)
					if relative_path.base.ends_with (Interface_ending) then
						interface_list.extend (relative_path)
					elseif relative_path.base.ends_with (Implementation_ending) then
						implementation_list.extend (relative_path)
					end
				end
			end
		end

feature -- Status query

	is_empty: BOOLEAN
		do
			Result := interface_list.is_empty
		end

feature -- Basic operations

	normalize_locations
		-- normalize location of classes with file-names ending with "_imp.e"
		local
			actual_list: EL_FILE_PATH_LIST; found: BOOLEAN
		do
			lio.put_labeled_string ("ECF", ecf_name)
			lio.put_new_line
			lio.put_path_field (" Cluster", cluster_dir)
			lio.put_new_line
			across interface_list as path loop
				lio.put_path_field ("Source", path.item)
				lio.put_new_line
				actual_list := selected_implementation_list (path.item)
				across actual_list as imp_path loop
					lio.put_path_field ("Actual", imp_path.item)
					lio.put_new_line
				end
				if actual_list.count = 1 and then is_implementation (Common_imp, actual_list.first_path) then
					copy_if_different (actual_list.first_path, target_implementation (Common_imp, path.item))
				else
					across actual_list as actual_imp loop
						found := False
						across Unix_and_windows_imp as imp_steps until found loop
							if is_implementation (imp_steps.item, actual_imp.item) then
								copy_if_different (actual_imp.item, target_implementation (imp_steps.item, path.item))
								found := True
							end
						end
					end
				end
				lio.put_new_line
			end
			lio.put_new_line
		end

feature {NONE} -- Implementation

	copy_if_different (actual_path, target_path: EL_FILE_PATH)
		do
			if actual_path /~ target_path then
				lio.put_labeled_string ("copy", actual_path.to_string)
				lio.put_labeled_string (" to", target_path)
				if Execution_environment.is_finalized_executable then
					Execution_environment.push_current_working (cluster_dir)

					File_system.make_directory (target_path.parent)
					OS.move_file (actual_path, target_path)
					File_system.delete_empty_branch (actual_path.parent)

					Execution_environment.pop_current_working

					lio.put_line ("Press 'y' to continue")
					lio.put_new_line
					from until User_input.entered_letter ('y') loop
					end
				end
			end
		end

	is_implementation (imp_steps: EL_PATH_STEPS; source_steps: EL_PATH_STEPS): BOOLEAN
		do
			if source_steps.starts_with (imp_steps) or else source_steps.has_sub_steps (Spec_table [imp_steps]) then
				Result := True
			end
		end

	selected_implementation_list (interface_path: EL_FILE_PATH): EL_FILE_PATH_LIST
		local
			imp_name, interface_name: ZSTRING
		do
			interface_name := interface_path.base_sans_extension
			create Result.make_with_count (2)
			across implementation_list as path loop
				imp_name := path.item.base_sans_extension
				if imp_name.starts_with (interface_name)
					and then imp_name.substring_end (interface_name.count + 1) ~ MP_ending
				then
					Result.extend (path.item)
				end
			end
		end

	target_implementation (imp_dir: EL_DIR_PATH; interface_path: EL_FILE_PATH): EL_FILE_PATH
		do
			Result := imp_dir + interface_path.twin
			Result.base.insert_string (MP_ending, Result.dot_index)
		end

feature {NONE} -- Internal attributes

	cluster_dir: EL_DIR_PATH

	ecf_name: ZSTRING

	implementation_list: EL_FILE_PATH_LIST

	interface_list: EL_FILE_PATH_LIST

feature {NONE} -- Constants

	Unix_and_windows_imp: ARRAY [EL_PATH_STEPS]
		once
			Result := << "imp_unix", "imp_mswin" >>
		end

	Common_imp: EL_PATH_STEPS
		once
			Result := "imp_common"
		end

	MP_ending: ZSTRING
		once
			Result := "mp"
		end

	Spec_table: HASH_TABLE [EL_PATH_STEPS, EL_PATH_STEPS]
		-- platform specification table
		once
			create Result.make_equal (3)
			Result [Common_imp] := "spec/common"

			Result [Unix_and_windows_imp [1]] := "spec/unix"
			Result [Unix_and_windows_imp [2]] := "spec/windows"
		end

end
