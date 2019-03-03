note
	description: "Duplicity config"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-03-02 10:59:26 GMT (Saturday 2nd March 2019)"
	revision: "1"

deferred class
	DUPLICITY_CONFIG

inherit
	EL_BUILDABLE_FROM_PYXIS
		rename
			make_from_file as make
		export
			{EL_COMMAND_CLIENT} make
		redefine
			make_default
		end

	EL_SHARED_ENVIRONMENTS

feature {NONE} -- Initialization

	make_default
		do
			create encryption_key.make_empty
			create name.make_empty
			create destination_dir_list.make (5)
			create target_dir
			create exclude_any_list.make_empty
			create exclude_files_list.make_empty
			Precursor
		end

feature {NONE} -- Internal attributes

	encryption_key: ZSTRING

	destination_dir_list: EL_ARRAYED_LIST [EL_DIR_URI_PATH]

	exclude_any_list: EL_ZSTRING_LIST

	exclude_files_list: EL_ZSTRING_LIST

	name: ZSTRING

	target_dir: EL_DIR_PATH

feature {NONE} -- Build from XML

	append_destination_dir
		local
			steps: EL_PATH_STEPS
		do
			steps := node.to_string
			steps.expand_variables
			destination_dir_list.extend (steps.to_string)
		end

	append_exclude_any
		do
			create exclude_any_list.make_with_lines (node.to_string)
		end

	append_exclude_files
		local
			parent_dir: ZSTRING
		do
			create exclude_files_list.make_with_lines (node.to_string)
			parent_dir := target_dir.base
			parent_dir.append_character (Operating.Directory_separator)

			across exclude_files_list as file loop
				file.item.prepend_string (parent_dir)
			end
		end

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["@encryption_key",			agent do encryption_key := node end],
				["@name",						agent do name := node end],
				["@target_dir",				agent do target_dir := node.to_expanded_dir_path end],

				["destination/text()",		agent append_destination_dir],
				["exclude-any/text()",		agent append_exclude_any],
				["exclude-files/text()",	agent append_exclude_files]
			>>)
		end

feature {NONE} -- Constants

	Root_node_name: STRING = "duplicity"

end
