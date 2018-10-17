note
	description: "Publishes an Eiffel repository as a website"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-17 13:47:17 GMT (Wednesday 17th October 2018)"
	revision: "12"

class
	REPOSITORY_PUBLISHER

inherit
	EL_COMMAND

	EL_BUILDABLE_FROM_PYXIS
		redefine
			make_default, building_action_table, on_context_return
		end

	EL_ZSTRING_CONSTANTS

	EL_FILE_PROGRESS_TRACKER

	EL_MODULE_LIO

	EL_MODULE_USER_INPUT

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_OS

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_file_path: EL_FILE_PATH; a_version: STRING; a_thread_count: INTEGER)
		do
			config_path := a_file_path; version := a_version; thread_count := a_thread_count
			make_from_file (a_file_path)
		ensure then
			has_name: not name.is_empty
			has_at_least_one_source_tree: not ecf_list.is_empty
		end

	make_default
			--
		do
			create name.make_empty
			create ecf_list.make (10)
			create note_fields.make (2); note_fields.compare_objects
			create templates.make
			create root_dir
			create output_dir
			create example_classes.make (500)
			create ftp_sync.make
			create web_address.make_empty
			Precursor
		end

feature -- Access

	example_classes: EL_ARRAYED_LIST [EIFFEL_CLASS]
		-- Client examples list

	config_path: EL_FILE_PATH
		-- config file path

	ftp_sync: EL_BUILDER_CONTEXT_FTP_SYNC

	github_url: EL_DIR_URI_PATH

	name: ZSTRING

	note_fields: EL_ZSTRING_LIST
		-- note fields included in output

	output_dir: EL_DIR_PATH

	root_dir: EL_DIR_PATH

	sorted_tree_list: like ecf_list
		do
			ecf_list.sort
			Result := ecf_list
		end

	templates: REPOSITORY_HTML_TEMPLATES

	ecf_list: EL_SORTABLE_ARRAYED_LIST [EIFFEL_CONFIGURATION_FILE]

	version: STRING

	web_address: ZSTRING

	thread_count: INTEGER

feature -- Basic operations

	execute
		local
			github_contents: GITHUB_REPOSITORY_CONTENTS_MARKDOWN
			console_display: EL_CONSOLE_FILE_PROGRESS_DISPLAY; listener: like progress_listener
		do
			log_thread_count
			ftp_sync.set_root_dir (output_dir)

			if version /~ previous_version then
				output_sub_directories.do_if (agent OS.delete_tree, agent {EL_DIR_PATH}.exists)
			end

			example_classes.wipe_out
			across ecf_list as tree loop
				tree.item.read_source_files
				across tree.item.directory_list as directory loop
					across directory.item.class_list as eiffel_class loop
						ftp_sync.extend (eiffel_class.item)
					end
				end
			end
			across pages as page loop
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
				lio.put_string ("Synchronize with website (y/n) ")
				if User_input.entered_letter ('y') then
					lio.put_new_line
					create console_display.make
					listener := console_display.new_progress_listener
					listener.set_final_tick_count (1000)
					track_progress (listener, agent ftp_sync.login_and_upload, agent lio.put_line ("Synchronized"))
					ftp_sync.save
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

feature {NONE} -- Factory

	new_ecf_pages: EL_SORTABLE_ARRAYED_LIST [EIFFEL_CONFIGURATION_INDEX_PAGE]
		do
			create Result.make (ecf_list.count)
			across ecf_list as tree loop
				Result.extend (create {EIFFEL_CONFIGURATION_INDEX_PAGE}.make (Current, tree.item))
			end
			Result.sort
		end

feature {NONE} -- Implementation

	log_thread_count
		do
			lio.put_integer_field ("Thread count", thread_count)
			lio.put_new_line
		end

	previous_version: STRING
		do
			if version_path.exists then
				Result := File_system.plain_text (version_path)
			else
				create Result.make_empty
			end
		end

	pages: EL_ARRAYED_LIST [REPOSITORY_HTML_PAGE]
		local
			ecf_pages: like new_ecf_pages
		do
			ecf_pages := new_ecf_pages
			create Result.make (ecf_pages.count + 1)
			Result.extend (create {REPOSITORY_SITEMAP_PAGE}.make (Current, ecf_pages))
			Result.append (ecf_pages)
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

	set_template_context
		do
			templates.set_config_dir (config_path.parent)
			set_next_context (templates)
		end

	building_action_table: EL_PROCEDURE_TABLE
		do
			create Result.make (<<
				["@name", 							agent do name := node.to_string end],
				["@output-dir",		 			agent do output_dir := node.to_expanded_dir_path end],
				["@root-dir",	 					agent do root_dir := node.to_expanded_dir_path end],
				["@github-url", 					agent do github_url := node.to_string end],
				["@web-address", 					agent do web_address := node.to_string end],

				["templates",						agent set_template_context],
				["ecf-list/ecf", 					agent do set_next_context (create {ECF_INFO}.make) end],
				["ftp-site", 						agent do set_next_context (ftp_sync) end],
				["include-notes/note/text()", agent do note_fields.extend (node.to_string) end]
			>>)
		end

	on_context_return (context: EL_EIF_OBJ_XPATH_CONTEXT)
		local
			ecf_path: EL_FILE_PATH
		do
			if attached {ECF_INFO} context as ecf then
				ecf_path := root_dir + ecf.path
				if ecf_path.exists then
					ecf_list.extend (create {EIFFEL_CONFIGURATION_FILE}.make (Current, ecf))
				else
					lio.put_path_field ("Cannot find", ecf_path)
					lio.put_new_line
				end
			end
		end

feature {NONE} -- Constants

	Root_node_name: STRING = "publish-repository"

end
