note
	description: "Publishes an Eiffel repository as a website"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-15 11:09:18 GMT (Monday 15th March 2021)"
	revision: "33"

class
	REPOSITORY_PUBLISHER

inherit
	EL_COMMAND

	EL_BUILDABLE_FROM_PYXIS
		redefine
			make_default, on_context_return
		end

	EL_ZSTRING_CONSTANTS

	EL_MODULE_TRACK

	EL_MODULE_CONSOLE

	EL_MODULE_LIO

	EL_MODULE_USER_INPUT

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LOG_MANAGER

	EL_MODULE_OS

	EL_MODULE_EXCEPTION

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_file_path: EL_FILE_PATH; a_version: STRING; a_thread_count: INTEGER)
		do
			config_path := a_file_path; version := a_version; thread_count := a_thread_count
			log_thread_count
			create parser.make (Current)
			make_from_file (a_file_path)
			parser.update (True)

			-- Necessary to sort examples to ensure routine `{LIBRARY_CLASS}.sink_source_subsitutions'
			-- makes a consistent value for make `current_digest'
			example_classes.sort
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
			create ftp_sync.make
			create web_address.make_empty
			create ise_template
			Precursor
		end

feature -- Access

	config_path: EL_FILE_PATH
		-- config file path

	ecf_list: EIFFEL_CONFIGURATION_LIST [EIFFEL_CONFIGURATION_FILE]

	example_classes: EL_SORTABLE_ARRAYED_LIST [EIFFEL_CLASS]
		-- Client examples list

	ftp_sync: EL_FTP_SYNC_BUILDER_CONTEXT

	github_url: EL_DIR_URI_PATH

	name: ZSTRING

	note_fields: EL_ZSTRING_LIST
		-- note fields included in output

	output_dir: EL_DIR_PATH

	root_dir: EL_DIR_PATH

	templates: REPOSITORY_HTML_TEMPLATES

	thread_count: INTEGER

	version: STRING

	web_address: ZSTRING

feature -- Basic operations

	execute
		local
			github_contents: GITHUB_REPOSITORY_CONTENTS_MARKDOWN
		do
			ftp_sync.set_root_dir (output_dir)

			if version /~ previous_version then
				output_sub_directories.do_if (agent OS.delete_tree, agent {EL_DIR_PATH}.exists)
			end

			ecf_list.sink_source_subsitutions
			ecf_list.fill_ftp_sync

			lio.put_new_line
			across ecf_list.to_html_page_list as page loop
				if page.item.is_modified then
					page.item.serialize
				end
				ftp_sync.extend (page.item)
			end
			ftp_sync.update
			ftp_sync.remove_local (output_dir)

			create github_contents.make (Current, output_dir + "Contents.md")
			github_contents.serialize
			write_version

			if ftp_sync.has_changes and not ftp_sync.ftp.is_default_state then
				if ok_to_synchronize then
					lio.put_new_line
					Track.progress (Console_display, ftp_sync.operation_count, agent ftp_sync.login_and_upload)
					lio.put_line ("Synchronized")
				end
			end
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
			lio.put_string ("Synchronize with website (y/n) ")
			Result := User_input.entered_letter ('y')
		end

feature {NONE} -- Implementation

	log_thread_count
		do
			lio.put_integer_field ("Thread count", thread_count)
			lio.put_new_line
		end

	output_sub_directories: EL_ARRAYED_LIST [EL_DIR_PATH]
		local
			set: EL_HASH_SET [ZSTRING]; first_step: ZSTRING
			relative_path: EL_DIR_PATH
		do
			create Result.make (10)
			create set.make_equal (10)
			across ecf_list as tree loop
				relative_path := tree.item.relative_dir_path
				first_step := relative_path.first_step
				set.put (first_step)
				if set.inserted then
					Result.extend (output_dir.joined_dir_path (first_step))
				end
			end
		end

	previous_version: STRING
		do
			if version_path.exists then
				Result := File_system.plain_text (version_path)
			else
				create Result.make_empty
			end
		end

	version_path: EL_FILE_PATH
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
				["@name", 							agent do name := node.to_string end],
				["@output-dir",		 			agent do output_dir := node.to_expanded_dir_path end],
				["@root-dir",	 					agent do root_dir := node.to_expanded_dir_path end],
				["@github-url", 					agent do github_url := node.to_string end],
				["@web-address", 					agent do web_address := node.to_string end],
				["@ise-library",					agent do ise_template.library := node end],
				["@ise-contrib",					agent do ise_template.contrib := node end],

				["templates",						agent set_template_context],
				["ecf-list/ecf", 					agent do set_next_context (create {ECF_INFO}.make) end],
				["ftp-site", 						agent do set_next_context (ftp_sync) end],
				["include-notes/note/text()", agent do note_fields.extend (node.to_string) end]
			>>)
		end

	on_context_return (context: EL_EIF_OBJ_XPATH_CONTEXT)
		local
			ecf_path: EL_FILE_PATH; ecf: ECF_INFO
			root_node: EL_XPATH_ROOT_NODE_CONTEXT
			has_error: BOOLEAN
		do
			if attached {ECF_INFO} context as info then
				ecf := info.normalized
				ecf_path := root_dir + ecf.path
				if ecf_path.exists then
					create root_node.make_from_file (ecf_path)
					if root_node.parse_failed then
						lio.put_path_field ("Configuration parse failed", ecf_path)
						has_error := True

					elseif ecf.cluster_count (root_node) = 0 then
						lio.put_path_field ("Configuration", ecf_path)
						lio.put_new_line
						lio.put_labeled_string ("Zero nodes found for xpath", ecf.cluster_xpath)
						has_error := True

					elseif root_node.is_xpath (Xpath_all_classes) then
						ecf_list.extend (create {EIFFEL_LIBRARY_CONFIGURATION_FILE}.make (Current, ecf, root_node))
					else
						ecf_list.extend (create {EIFFEL_CONFIGURATION_FILE}.make (Current, ecf, root_node))
					end
				else
					lio.put_path_field ("Cannot find", ecf_path)
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
			ise_template.library.replace_substring_general_all ("%%S", "%S")
			create table.make (ise_template.library, ise_template.contrib)

			templates.set_config_dir (config_path.parent)
			set_next_context (templates)
		end

feature {EIFFEL_CONFIGURATION_FILE} -- Internal attributes

	parser: EIFFEL_CLASS_PARSER

	ise_template: TUPLE [library, contrib: ZSTRING]

feature {NONE} -- Constants

	Root_node_name: STRING = "publish-repository"

	Xpath_all_classes: STRING = "/system/target/root/@all_classes"

end