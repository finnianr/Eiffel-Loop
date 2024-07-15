note
	description: "Delete log files for all logged applications, keeping newest up to `keep_count'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-15 13:18:16 GMT (Monday 15th July 2024)"
	revision: "1"

class
	EL_LOG_PRUNE_COMMAND

inherit
	EL_APPLICATION_COMMAND

	EL_MODULE_DIRECTORY; EL_MODULE_FILE_SYSTEM; EL_MODULE_LIO; EL_MODULE_USER_INPUT

	EL_SHARED_APPLICATION_LIST; EL_SHARED_APPLICATION

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_log_name: ZSTRING; a_keep_count: INTEGER)
		do
			log_name := a_log_name; keep_count := a_keep_count
		end

feature -- Constants

	Description: STRING = "Delete application log files, keeping newest"

feature -- Basic operations

	execute
		local
			manager: EL_LOG_MANAGER; output_dir: DIR_PATH; deleting: BOOLEAN
			deletion_list: EL_FILE_PATH_LIST
		do
			lio.put_line (log_name + " logs")
			lio.put_new_line
			create deletion_list.make (30)
			across Application_list as app_list loop
				if attached {EL_LOGGED_APPLICATION} app_list.item as app then
					deleting := False; deletion_list.wipe_out
					lio.put_line (app.generator)
					output_dir := Directory.App_data.joined_dir_tuple ([app.option_name, app.Logs_dir_name])
					if output_dir.exists then
						create manager.make (False, output_dir)
						if attached manager.new_log_path_list (log_name) as log_path_list then
							if log_path_list.is_empty then
								lio.put_labeled_string ("Empty directory", output_dir)
								lio.put_new_line
							else
								lio.put_line ("Keeping")
								across log_path_list as list loop
									if list.cursor_index = keep_count + 1 then
										lio.put_line ("Deleting")
										deleting := True
									end
									lio.put_index_labeled_string (list, Void, list.item)
									lio.put_new_line
									if deleting then
										deletion_list.extend (list.item)
									end
								end
								if User_input.approved_action_y_n ("Are you sure?") then
									across deletion_list as list loop
										File_system.remove_file (list.item)
									end
								end
							end
						end
					else
						lio.put_line ("No logs directory")
					end
					lio.put_new_line
				end
			end
		end

feature {NONE} -- Internal attributes

	keep_count: INTEGER

	log_name: ZSTRING
		-- log name prefix

end