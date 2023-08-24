note
	description: "[
		Publishes an Eiffel repository as a website based on a set of [./library/evolicity.html Evolicity templates]
		and a configuration file listing the libraries and clusters to include.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-24 6:47:14 GMT (Thursday 24th August 2023)"
	revision: "69"

class
	REPOSITORY_PUBLISHER

inherit
	EL_BUILDABLE_FROM_PYXIS
		redefine
			make_default, on_context_return
		end

	EL_MODULE_CONSOLE; EL_MODULE_EXCEPTION; EL_MODULE_FILE; EL_MODULE_LIO; EL_MODULE_LOG_MANAGER

	EL_MODULE_OS; EL_MODULE_TRACK; EL_MODULE_USER_INPUT

	PUBLISHER_CONSTANTS

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_file_path: FILE_PATH; a_version: STRING; a_cpu_percentage: INTEGER)
		local
			parser: EIFFEL_CLASS_PARSER
		do
			config_path := a_file_path; version := a_version; cpu_percentage := a_cpu_percentage
			log_cpu_percentage
			make_from_file (a_file_path)

			create parser.make (cpu_percentage)
			across ecf_list as ecf loop
				ecf.item.read_class_source (parser)
			end
			parser.apply_final

			-- Necessary to sort examples to ensure routine `{LIBRARY_CLASS}.sink_source_subsitutions'
			-- makes a consistent value for make `current_digest'
			example_classes.ascending_sort
		ensure then
			has_name: not name.is_empty
			has_at_least_one_source_tree: not ecf_list.is_empty
		end

	make_default
		do
			create name.make_empty
			create ecf_list.make (Current)
			create note_fields.make (2); note_fields.compare_objects
			create templates.make
			create root_dir
			create output_dir
			create example_classes.make (500)
			create ftp_configuration.make_default
			create web_address.make_empty
			create ise_template
			Precursor
		end

feature -- Access

	config_path: FILE_PATH
		-- config file path

	ftp_host: STRING
		do
			Result := ftp_configuration.url.host
		end

	ecf_list: EIFFEL_CONFIGURATION_LIST [EIFFEL_CONFIGURATION_FILE]

	example_classes: EL_SORTABLE_ARRAYED_LIST [EIFFEL_CLASS]
		-- Client examples list

	github_url: EL_DIR_URI_PATH

	name: ZSTRING

	note_fields: EL_ZSTRING_LIST
		-- note fields included in output

	output_dir: DIR_PATH

	root_dir: DIR_PATH

	templates: REPOSITORY_HTML_TEMPLATES

	cpu_percentage: INTEGER

	version: STRING

	web_address: ZSTRING

feature -- Basic operations

	ask_user
		local
			response: ZSTRING
		do
			response := User_input.line ("Press <Enter> to update " + User_input.ESC_to_quit)
			user_quit := response.is_character ('%/27/')
		end

	execute
		local
			github_contents: GITHUB_REPOSITORY_CONTENTS_MARKDOWN
			sync_manager: EL_FILE_SYNC_MANAGER; current_set: EL_MEMBER_SET [EL_FILE_SYNC_ITEM]
			update_checker: EIFFEL_CLASS_UPDATE_CHECKER
		do
			if execution_count > 0 then
				create update_checker.make (cpu_percentage)
				across ecf_list as list loop
					list.item.update_source_files (update_checker)
				end
				update_checker.apply_final
			end
			create current_set.make (3000)
			if version /~ previous_version then
				output_sub_directories.do_if (agent OS.delete_tree, agent {DIR_PATH}.exists)
			end
			ecf_list.sink_source_subsitutions
			ecf_list.get_sync_items (current_set)

			lio.put_new_line
			across ecf_list.to_html_page_list as page loop
				if page.item.is_modified then
					page.item.serialize
				end
				current_set.put (page.item)
			end
			create github_contents.make (Current, output_dir + "Contents.md")
			github_contents.serialize
			write_version

			lio.put_line ("Creating sync manager")
			if current_set.is_empty then
				create sync_manager.make_empty (output_dir, ftp_host, Html)
			else
				create sync_manager.make (current_set)
			end
			if sync_manager.has_changes and then ok_to_synchronize then
				if attached new_medium as medium then
					login (medium)
					if is_logged_in then
						sync_manager.track_update (medium, Console_display)
						lio.put_line ("Synchronized")
					else
						lio.put_line ("Login failed")
					end
				end
			else
				lio.put_line ("No changes")
			end
			execution_count := execution_count + 1
		end

	set_output_dir (a_output_dir: like output_dir)
		do
			output_dir := a_output_dir
		end

feature -- Status query

	has_version_changed: BOOLEAN
		do
			Result := version /~ previous_version
		end

	ok_to_synchronize: BOOLEAN
		do
			Result := User_input.approved_action_y_n ("Synchronize with website?")
		end

	is_logged_in: BOOLEAN

	user_quit: BOOLEAN

feature {NONE} -- Implementation

	authenticate_ftp
		do
			ftp_configuration.authenticate (Void)
		end

	check_pecf_source (ecf_path: FILE_PATH)
		-- check if pecf format source has been modified
		local
			pecf_path: FILE_PATH; converter: PYXIS_ECF_CONVERTER
		do
			pecf_path := ecf_path.with_new_extension (Extension_pecf)
			if pecf_path.exists and then pecf_path.modification_time > ecf_path.modification_time then
				create converter.make (pecf_path, ecf_path)
				converter.execute
			end
		end

	login (medium: EL_FILE_SYNC_MEDIUM)
		do
			if attached {EL_FTP_FILE_SYNC_MEDIUM} medium as ftp then
				ftp.login
				is_logged_in := ftp.is_logged_in
			else
				is_logged_in := True
			end
		end

	log_cpu_percentage
		do
			lio.put_labeled_substitution ("CPU resource usage", "%S%% of available processors", [cpu_percentage])
			lio.put_new_line
		end

	new_medium: EL_FILE_SYNC_MEDIUM
		do
			create {EL_FTP_FILE_SYNC_MEDIUM} Result.make_write (ftp_configuration)
		end

	output_sub_directories: EL_ARRAYED_LIST [DIR_PATH]
		local
			set: EL_HASH_SET [ZSTRING]; first_step: ZSTRING
			relative_path: DIR_PATH
		do
			create Result.make (10)
			create set.make (10)
			across ecf_list as tree loop
				relative_path := tree.item.relative_dir_path
				first_step := relative_path.first_step
				set.put (first_step)
				if set.inserted then
					Result.extend (output_dir #+ first_step)
				end
			end
		end

	previous_version: STRING
		do
			if version_path.exists then
				Result := File.plain_text (version_path)
			else
				create Result.make_empty
			end
		end

	version_path: FILE_PATH
		do
			Result := output_dir + "version.txt"
		end

	write_version
		local
			text_out: PLAIN_TEXT_FILE
		do
			create text_out.make_open_write (version_path)
			text_out.put_string (version)
			text_out.close
		end

feature {NONE} -- Build from Pyxis

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["@output_dir",		 			agent do output_dir := node.to_expanded_dir_path end],
				["@name", 							agent do node.set (name) end],
				["@root_dir",	 					agent do root_dir := node.to_expanded_dir_path end],
				["@github_url", 					agent do github_url := node.to_string end],
				["@web_address", 					agent do node.set (web_address) end],
				["@ise_library",					agent do ise_template.library := node end],
				["@ise_contrib",					agent do ise_template.contrib := node end],

				["templates",						agent set_template_context],
				["ecf-list/ecf", 					agent do set_next_context (create {ECF_INFO}.make) end],
				["ftp-site", 						agent do set_next_context (ftp_configuration) end],
				["include-notes/note/text()", agent do note_fields.extend (node.to_string) end]
			>>)
		end

	on_context_return (context: EL_EIF_OBJ_XPATH_CONTEXT)
		local
			ecf_path: FILE_PATH; ecf: ECF_INFO; root_node: EL_XML_DOC_CONTEXT; has_error: BOOLEAN
		do
			authenticate_ftp

			if attached {ECF_INFO} context as info then
				ecf := info.normalized
				ecf_path := root_dir + ecf.path
				if ecf_path.exists then
					check_pecf_source (ecf_path)
					create root_node.make_from_file (ecf_path)
					if root_node.parse_failed and then attached root_node.last_exception as last then
						lio.put_path_field ("Failed to parse", ecf_path)
						lio.put_new_line
						last.put_error (lio)
						has_error := True

					elseif ecf.cluster_count (root_node) = 0 then
						lio.put_path_field ("Configuration %S", ecf_path)
						lio.put_new_line
						lio.put_labeled_string ("Zero nodes found for xpath", ecf.cluster_xpath)
						has_error := True

					elseif root_node.is_xpath (Xpath_all_classes) then
						ecf_list.extend (create {EIFFEL_LIBRARY_CONFIGURATION_FILE}.make (Current, ecf, root_node))
					else
						ecf_list.extend (create {EIFFEL_CONFIGURATION_FILE}.make (Current, ecf, root_node))
					end
				else
					lio.put_path_field ("Cannot find %S", ecf_path)
					has_error := True
				end
				if has_error then
					lio.put_new_line
					User_input.press_enter
					Exception.raise_developer ("Configuration error", [])
				end
			end
		end

	set_template_context
		local
			table: ISE_CLASS_TABLE
		do
			ise_template.library.replace_substring_all ("%%S", "%S")
			create table.make (ise_template.library, ise_template.contrib)

			templates.set_config_dir (config_path.parent)
			set_next_context (templates)
		end

feature {EIFFEL_CONFIGURATION_FILE} -- Internal attributes

	ise_template: TUPLE [library, contrib: ZSTRING]

	ftp_configuration: EL_FTP_CONFIGURATION

	execution_count: INTEGER

feature {NONE} -- Constants

	Root_node_name: STRING = "publish-repository"

	Extension_pecf: ZSTRING
		once
			Result := "pecf"
		end

	Xpath_all_classes: STRING = "/system/target/root/@all_classes"

end