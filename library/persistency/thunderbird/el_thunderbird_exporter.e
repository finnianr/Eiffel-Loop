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
	EL_BUILDABLE_FROM_PYXIS
		redefine
			make_default, make_from_file, building_action_table
		end

	EL_MODULE_LIO

feature {NONE} -- Initialization

	make_default
		do
			create account.make (0)
			create character_set.make_default
			home_dir := "$HOME"
			home_dir.expand
			Precursor
		end

	make_from_file (a_file_path: EL_FILE_PATH)
		local
			profile_lines: EL_FILE_LINE_SOURCE; mail_dir_path_steps: EL_PATH_STEPS
		do
			Precursor (a_file_path)
			lio.put_labeled_string ("Account", account)
			lio.put_new_line
			lio.put_path_field ("export", export_dir)
			lio.put_new_line

			mail_dir_path_steps := home_dir
			mail_dir_path_steps.extend (".thunderbird")
			create profile_lines.make (mail_dir_path_steps.as_directory_path + "profiles.ini")
			across profile_lines as line loop
				if line.item.starts_with (Path_equals) then
					mail_dir_path_steps.extend (line.item.split ('=').last)
				end
			end
			mail_dir_path_steps.extend ("Mail")
			mail_dir_path_steps.extend (account)
			mail_dir := mail_dir_path_steps
			lio.put_path_field ("Mail", mail_dir)
			lio.put_new_line_x2
		end

feature {NONE} -- Internal attributes

	account: STRING
		-- account name

	character_set: EL_ENCODING

	export_dir: EL_DIR_PATH

	home_dir: EL_DIR_PATH

	mail_dir: EL_DIR_PATH

feature {NONE} -- Build from XML

	Root_node_name: STRING = "thunderbird"

	building_action_table: EL_PROCEDURE_TABLE
			--
		do
			create Result.make (<<
				["@account",		agent do account := node end],
				["@home_dir",		agent do home_dir := node.to_expanded_dir_path end],
				["@charset",		agent do character_set.set_from_name (node.to_string_8) end],
				["@export_dir",	agent do export_dir := node.to_expanded_dir_path end]
			>>)
		end

feature {NONE} -- Constants

	Path_equals: ZSTRING
		once
			Result := "Path="
		end

end
