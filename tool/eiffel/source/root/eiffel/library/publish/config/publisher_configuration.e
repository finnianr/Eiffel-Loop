note
	description: "Configuration for ${REPOSITORY_PUBLISHER} created from Pyxis formatted file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-07 7:04:13 GMT (Friday 7th June 2024)"
	revision: "3"

class
	PUBLISHER_CONFIGURATION

inherit
	EL_BUILDABLE_FROM_PYXIS
		rename
			make_from_file as make
		redefine
			make, make_default
		end

	EL_MODULE_TRACK

	EL_CHARACTER_32_CONSTANTS

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_path: FILE_PATH)
		do
			path := a_path
			Precursor (a_path)

		-- Insert ECF clusters
			from ecf_list.start until ecf_list.after loop
				if attached ecf_list.item as ecf and then ecf.path.base.has ('#') then
					ecf_list.replace (create {ECF_CLUSTER_INFO}.make (ecf))
				end
				ecf_list.forth
			end
			local_output_dir := output_dir.parent #+ Dot.joined ("ftp", output_dir.base)
			if not test_mode then
				ftp_site.authenticate (Void)
			end
		ensure then
			has_name: not name.is_empty
			has_at_least_one_source_tree: not ecf_list.is_empty
		end

	make_default
		do
			create copied_path_list.make (10)
			create ecf_list.make (50)
			create ftp_site.make_default
			create github_url
			create invalid_names_output_path
			create ise_template
			create name.make_empty
			create note_fields.make (2); note_fields.compare_objects
			create output_dir
			create root_dir
			create templates.make
			create version.make_empty
			create web_address.make_empty
			Precursor
		end

feature -- Access

	copied_path_list: EL_FILE_PATH_LIST
		-- list of files copied in test mode

	ftp_host: STRING
		do
			if test_mode then
				Result := local_output_dir.base
			else
				Result := ftp_site.url.host
			end
		end

	path: FILE_PATH
		-- config file path

	progress_display: EL_PROGRESS_DISPLAY
		do
			if test_mode then
				Result := Default_display
			else
				Result := Console_display
			end
		end

	version: STRING

feature -- File configured

	ecf_list: EL_ARRAYED_LIST [ECF_INFO]

	ftp_site: EL_FTP_CONFIGURATION

	github_url: EL_DIR_URI_PATH

	invalid_names_output_path: FILE_PATH
		-- Used by `REPOSITORY_NOTE_LINK_CHECKER'

	ise_template: TUPLE [library, contrib: ZSTRING]

	local_output_dir: DIR_PATH
		-- location of output files during testing

	name: ZSTRING

	note_fields: EL_ZSTRING_LIST
		-- note fields included in output

	output_dir: DIR_PATH

	root_dir: DIR_PATH

	templates: REPOSITORY_HTML_TEMPLATES

	web_address: ZSTRING

feature -- Status query

	test_mode: BOOLEAN

feature -- Factory

	new_medium: EL_FILE_SYNC_MEDIUM
		local
			local_medium: TEST_FILE_SYNC_MEDIUM
		do
			if test_mode then
				create local_medium.make (copied_path_list)
				local_medium.set_remote_home (local_output_dir)
				Result := local_medium

			elseif ftp_site.prosite_ftp then
				create {EL_PROSITE_FTP_FILE_SYNC_MEDIUM} Result.make_write (ftp_site)
			else
				create {EL_FTP_FILE_SYNC_MEDIUM} Result.make_write (ftp_site)
			end
		end

feature {NONE} -- Build from Pyxis

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["@github_url",					 agent do github_url := node.to_string end],
				["@invalid_names_output_path", agent do invalid_names_output_path := node.to_expanded_file_path end],
				["@ise_library",					 agent do ise_template.library := node end],
				["@ise_contrib",					 agent do ise_template.contrib := node end],
				["@name",							 agent do node.set (name) end],
				["@output_dir",					 agent do output_dir := node.to_expanded_dir_path end],
				["@root_dir",						 agent do root_dir := node.to_expanded_dir_path end],
				["@test_mode",						 agent do test_mode := node end],
				["@web_address",					 agent do node.set (web_address) end],

				["ecf-list/ecf",					 agent do set_collection_context (ecf_list, create {ECF_INFO}.make) end],
				["ftp-site",						 agent do set_next_context (ftp_site) end],
				["include-notes/note/text()",	 agent do note_fields.extend (node.to_string) end],
				["templates",						 agent set_template_context]
			>>)
		end

	set_template_context
		local
			table: ISE_CLASS_TABLE
		do
			ise_template.library.replace_substring_all ("%%S", "%S")
			create table.make (ise_template.library, ise_template.contrib)

			templates.set_config_dir (path.parent)
			set_next_context (templates)
		end

feature {NONE} -- Constants

	Root_node_name: STRING = "publish-repository"

end