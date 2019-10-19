note
	description: "Summary description for {EL_COPIED_FILE_DATA_TEST_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_COPIED_FILE_DATA_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET
		redefine
			on_prepare
		end

	EL_MODULE_DIRECTORY

	EL_MODULE_OS

feature {NONE} -- Events

	on_prepare
		local
			relative_path: EL_FILE_PATH; relative_dir: EL_DIR_PATH
			list: like source_file_list
		do
			Precursor
			list := source_file_list
			create file_list.make_with_count (list.count)
			across list as path loop
				relative_path := Work_area_dir + path.item.relative_path (eiffel_loop_dir)
				relative_dir := relative_path.parent
				OS.File_system.make_directory (relative_dir)
				OS.copy_file (path.item, relative_dir)
				file_list.extend (relative_path)
			end
		end

feature {NONE} -- Implementation

	source_file_list: LIST [EL_FILE_PATH]
		deferred
		end

feature {NONE} -- Internal attributes

	file_list: EL_FILE_PATH_LIST

feature {NONE} -- Constants

	Eiffel_loop: ZSTRING
		once
			Result := "Eiffel-Loop"
		end

	Eiffel_loop_dir: EL_DIR_PATH
		local
			steps: EL_PATH_STEPS
		do
			from
				steps := Directory.current_working
			until
				steps.is_empty or else steps.last ~ Eiffel_loop
			loop
				steps.remove_tail (1)
			end
			Result := steps
		end

end
