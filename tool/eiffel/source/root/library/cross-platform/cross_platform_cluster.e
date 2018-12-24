note
	description: "Cluster of cross platform implementations and interfaces"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-24 16:54:59 GMT (Monday 24th December 2018)"
	revision: "1"

class
	CROSS_PLATFORM_CLUSTER

inherit
	CROSS_PLATFORM_CONSTANTS

	EL_MODULE_LIO

	EL_MODULE_TUPLE

create
	make

feature {NONE} -- Initialization

	make (a_cluster_dir: EL_DIR_PATH; path_list: EL_FILE_PATH_LIST)
		local
			relative_path: EL_FILE_PATH
		do
			cluster_dir := a_cluster_dir
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

feature -- Basic operations

	normalize_locations
		-- normalize location of classes with file-names ending with "_imp.e"
		local
			target_path, actual_path: EL_FILE_PATH
			actual_list: EL_FILE_PATH_LIST
		do
			lio.put_path_field ("Cluster", cluster_dir)
			lio.put_new_line
			across interface_list as path loop
				lio.put_path_field ("Source", path.item)
				lio.put_new_line
				actual_list := selected_implementation_list (path.item)

				across Implementation_dir_list as dir loop
					target_path := target_implementation (dir.item, path.item)
					lio.put_path_field ("target", target_path)
					lio.put_new_line
					if not implementation_list.has (target_path) then
						actual_path := actual_implementation (dir.item, actual_list)
						lio.put_path_field ("actual", actual_path)
						lio.put_new_line
					end
				end
				lio.put_new_line
			end
			lio.put_new_line
		end

feature {NONE} -- Implementation

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

	actual_implementation (imp_dir: ZSTRING; actual_list: EL_FILE_PATH_LIST): EL_FILE_PATH
		local
			list: EL_ARRAYED_LIST [EL_FILE_PATH]
		do
			list := actual_list.query_if (agent is_implementation (imp_dir, ?))
			if list.count = 1 then
				Result := list.first
			else
				create Result
			end
		end

	is_implementation (imp_dir: ZSTRING; file_path: EL_FILE_PATH): BOOLEAN
		local
			steps: EL_PATH_STEPS
		do
			steps := file_path
			if steps.first ~ imp_dir then
				Result := True
			else
				steps.start
				steps.search (Platform_table [imp_dir])
				if not steps.after and then steps.index > 1 and then steps [steps.index - 1] ~ Spec then
					Result := True
				end
			end
		end

feature {NONE} -- Internal attributes

	cluster_dir: EL_DIR_PATH

	implementation_list: EL_FILE_PATH_LIST

	interface_list: EL_FILE_PATH_LIST

feature {NONE} -- Constants

	Implementation_dir_list: EL_ZSTRING_LIST
		once
			create Result.make_with_separator ("imp_unix, imp_mswin", ',', True)
		end

	Platform_table: EL_ZSTRING_HASH_TABLE [ZSTRING]
		once
			create Result.make_equal (2)
			Result [Implementation_dir_list.first] := "unix"
			Result [Implementation_dir_list.last] := "windows"
		end

	MP_ending: ZSTRING
		once
			Result := "mp"
		end

	Spec: ZSTRING
		once
			Result := "spec"
		end

end
