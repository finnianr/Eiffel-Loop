note
	description: "Publishes an Eiffel repository as a website"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-18 10:52:28 GMT (Wednesday 18th October 2017)"
	revision: "8"

class
	REPOSITORY_PUBLISHER

inherit
	EL_COMMAND

	EL_BUILDABLE_FROM_PYXIS
		redefine
			make_default, building_action_table
		end

	EL_STRING_CONSTANTS

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
			file_path := a_file_path; version := a_version; thread_count := a_thread_count
			make_from_file (a_file_path)
		ensure then
			has_name: not name.is_empty
			has_at_least_one_source_tree: not tree_list.is_empty
		end

	make_default
			--
		do
			create name.make_empty
			create tree_list.make (10)
			create note_fields.make (2); note_fields.compare_objects
			create templates.make
			create root_dir
			create output_dir
			create example_classes.make (500)
			create ftp_sync.make_default
			create web_address.make_empty
			Precursor
		end

feature -- Access

	example_classes: EL_ARRAYED_LIST [EIFFEL_CLASS]
		-- Client examples list

	file_path: EL_FILE_PATH
		-- config file path

	ftp_sync: EL_FTP_SYNC

	github_url: EL_DIR_URI_PATH

	name: ZSTRING

	note_fields: EL_ZSTRING_LIST
		-- note fields included in output

	output_dir: EL_DIR_PATH

	root_dir: EL_DIR_PATH

	sorted_tree_list: like tree_list
		do
			tree_list.sort
			Result := tree_list
		end

	templates: REPOSITORY_HTML_TEMPLATES

	tree_list: EL_SORTABLE_ARRAYED_LIST [REPOSITORY_SOURCE_TREE]

	version: STRING

	web_address: ZSTRING

	thread_count: INTEGER

feature -- Basic operations

	execute
		local
			relative_html_path: EL_FILE_PATH; sync_list: EL_ARRAYED_LIST [EL_FILE_PATH]
			github_contents: GITHUB_REPOSITORY_CONTENTS_MARKDOWN
			console_display: EL_CONSOLE_FILE_PROGRESS_DISPLAY; listener: like progress_listener
		do
			log_thread_count
			create sync_list.make (100)
			ftp_sync.set_root_dir (output_dir)

			if version /~ previous_version then
				output_sub_directories.do_if (agent OS.delete_tree, agent {EL_DIR_PATH}.exists)
			end

			example_classes.wipe_out
			across tree_list as tree loop
				tree.item.read_source_files
				across tree.item.directory_list as directory loop
					across directory.item.class_list as eiffel_class loop
						sync_list.extend (eiffel_class.item.html_path.relative_path (output_dir))
					end
				end
			end
			across pages as page loop
				relative_html_path := page.item.output_path.relative_path (output_dir)
				sync_list.extend (relative_html_path)
				if page.item.is_modified then
					page.item.serialize
					ftp_sync.extend_modified (relative_html_path)
				end
			end
			create github_contents.make (Current, output_dir + "Contents.md")
			github_contents.serialize
			write_version

			if not ftp_sync.ftp.is_default_state then
				lio.put_string ("Upload to website (y/n) ")
				if User_input.entered_letter ('y') then
					lio.put_new_line
					create console_display.make
					listener := console_display.new_progress_listener
					listener.set_final_tick_count (1000)
					track_progress (
						listener, agent ftp_sync.login_and_upload (sync_list), agent lio.put_line ("Synchronized")
					)
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

	new_source_tree_pages: EL_SORTABLE_ARRAYED_LIST [REPOSITORY_SOURCE_TREE_PAGE]
		do
			create Result.make (tree_list.count)
			across tree_list as tree loop
				Result.extend (create {REPOSITORY_SOURCE_TREE_PAGE}.make (Current, tree.item))
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
			source_tree_pages: like new_source_tree_pages
		do
			source_tree_pages := new_source_tree_pages
			create Result.make (source_tree_pages.count + 1)
			Result.extend (create {REPOSITORY_SITEMAP_PAGE}.make (Current, source_tree_pages))
			Result.append (source_tree_pages)
		end

	output_sub_directories: EL_ARRAYED_LIST [EL_DIR_PATH]
		local
			set: EL_HASH_SET [ZSTRING]; first_step: ZSTRING
			relative_path: EL_DIR_PATH
		do
			create Result.make (10)
			create set.make_equal (10)
			across tree_list as tree loop
				relative_path := tree.item.dir_path.relative_path (root_dir)
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
			templates.set_config_dir (file_path.parent)
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
				["sources/tree", 					agent set_tree_context],
				["ftp-site", 						agent do set_next_context (ftp_sync) end],
				["include-notes/note/text()", agent do note_fields.extend (node.to_string) end]
			>>)
		end

	set_tree_context
			--
		do
			tree_list.extend (create {like tree_list.item}.make (Current))
			set_next_context (tree_list.last)
		end

feature {NONE} -- Constants

	Root_node_name: STRING = "publish-repository"

end
