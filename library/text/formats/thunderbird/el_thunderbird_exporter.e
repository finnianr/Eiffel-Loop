note
	description: "Thunderbird exporter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-30 8:14:46 GMT (Sunday 30th September 2018)"
	revision: "5"

class
	EL_THUNDERBIRD_EXPORTER

inherit
	EL_MODULE_LIO

feature {NONE} -- Initialization

	make (a_account_name: ZSTRING; a_export_path, thunderbird_home_dir: EL_DIR_PATH)
		local
			profile_lines: EL_FILE_LINE_SOURCE; mail_dir_path_steps: EL_PATH_STEPS
		do
			account_name := a_account_name; export_path := a_export_path

			lio.put_labeled_string ("Account", a_account_name)
			lio.put_new_line
			lio.put_path_field ("export", a_export_path)
			lio.put_new_line

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
			lio.put_path_field ("Mail", mail_dir)
			lio.put_new_line_x2
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
