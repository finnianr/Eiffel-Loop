note
	description: "[
		Consecutively open in EiffelStudio all Eiffel projects with desktop launchers found in
		specified location. (recursive search)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-02 15:28:43 GMT (Thursday 2nd November 2023)"
	revision: "1"

class
	COMPILE_DESKTOP_PROJECTS

inherit
	EL_APPLICATION_COMMAND

	EL_MODULE_DIRECTORY; EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_LIO; EL_MODULE_OS
	EL_MODULE_TUPLE; EL_MODULE_USER_INPUT

create
	make

feature {EL_APPLICATION} -- Initialization

	make (a_search_dir: DIR_PATH)
		do
			search_dir := a_search_dir
			if attached Execution_environment.variable_dir_path (Var.eiffel) as eiffel_dir
				and then not eiffel_dir.is_empty
			then
				root_dir := eiffel_dir
			else
				root_dir := Directory.home
			end
		end

feature -- Constants

	Description: STRING = "[
		Consecutively open Eiffel projects using all desktop launchers under specified location
	]"

feature -- Basic operations

	execute
		local
			project_set: EL_HASH_SET [FILE_PATH]
		do
			create project_set.make (20)
			across OS.file_list (search_dir, "*.desktop") as list loop
				if attached new_launcher (list.item) as launcher and then launcher.is_valid then
					if not project_set.has (launcher.ecf_path) then
						lio.put_path_field ("Launcher", list.item.relative_path (Directory.home))
						lio.put_new_line
						lio.put_path_field ("Project", launcher.ecf_path.relative_path (root_dir))
						lio.put_new_line
						project_set.put (launcher.ecf_path)
						if User_input.approved_action_y_n ("Open " + launcher.ecf_path.base) then
							Launch_estudio.set_working_directory (launcher.ecf_path.parent)
							Launch_estudio.put_string (Var.name, launcher.ecf_path.base)
							Launch_estudio.execute
						end
						lio.put_new_line
					end
				end
			end
		end

feature {NONE} -- Implementation

	new_launcher (desktop_path: FILE_PATH): PROJECT_LAUNCHER_I
		do
			create {PROJECT_LAUNCHER_IMP} Result.make (desktop_path)
		end

feature {NONE} -- Internal attributes

	root_dir: DIR_PATH

	search_dir: DIR_PATH

feature {NONE} -- Constants

	Launch_estudio: EL_OS_COMMAND
		once
			create Result.make ("launch_estudio $NAME")
		end

	Var: TUPLE [eiffel, name: STRING]
		once
			create Result
			Tuple.fill (Result, "EIFFEL, NAME")
		end
end