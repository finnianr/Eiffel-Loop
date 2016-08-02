note
	description: "Summary description for {THUNDERBIRD_EXPORTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-05 5:05:11 GMT (Tuesday 5th July 2016)"
	revision: "1"

class
	THUNDERBIRD_EXPORTER

inherit
	EL_MODULE_LOG

feature {EL_SUB_APPLICATION} -- Initialization

	make (a_account_name: ZSTRING; a_export_path, thunderbird_home_dir: EL_DIR_PATH)
		local
			profile_lines: EL_FILE_LINE_SOURCE; mail_dir_path_steps: EL_PATH_STEPS
		do
			log.enter_with_args ("make", << a_account_name, a_export_path >>)
			account_name := a_account_name; export_path := a_export_path

			mail_dir_path_steps := thunderbird_home_dir
			mail_dir_path_steps.extend (".thunderbird")
			create profile_lines.make (mail_dir_path_steps.as_directory_path + "profiles.ini")
			across profile_lines as line loop
				if line.item.starts_with (Path_equals) then
					mail_dir_path_steps.extend (line.item.split ('=').last)
				end
			end
			mail_dir_path_steps.extend ("Mail")
			mail_dir_path_steps.extend (account_name)
			mail_dir := mail_dir_path_steps
			log.put_line (mail_dir.to_string)
			log.exit
		end

feature {NONE} -- Internal attributes

	account_name: STRING

	export_path: EL_DIR_PATH

	mail_dir: EL_DIR_PATH

feature {NONE} -- Constants

	Path_equals: ZSTRING
		once
			Result := "Path="
		end

end