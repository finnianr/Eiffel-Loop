note
	description: "Delete log files for all logged applications, keeping newest up to `keep_count'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-15 15:29:55 GMT (Monday 15th July 2024)"
	revision: "2"

class
	EL_LOG_PRUNE_COMMAND

inherit
	EL_APPLICATION_COMMAND

	EL_MODULE_DIRECTORY; EL_MODULE_LIO

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
			manager: EL_LOG_MANAGER; output_dir: DIR_PATH
		do
			lio.put_line (log_name + " logs")
			lio.put_new_line
			across Application_list as app_list loop
				if attached {EL_LOGGED_APPLICATION} app_list.item as app then
					lio.put_line (app.generator)
					output_dir := Directory.App_data.joined_dir_tuple ([app.option_name, app.Logs_dir_name])
					if output_dir.exists then
						create manager.make (False, output_dir)
						manager.keep_files (log_name, keep_count)
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