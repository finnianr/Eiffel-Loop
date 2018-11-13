note
	description: "[
		Command to create an XML file manifest of a target directory using either the default Evolicity template
		or an optional external Evolicity template. See class [$source EVOLICITY_SERIALIZEABLE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-13 12:18:53 GMT (Tuesday 13th November 2018)"
	revision: "1"

class
	EL_FILE_MANIFEST_COMMAND

inherit
	EVOLICITY_SERIALIZEABLE_AS_XML

	EL_COMMAND

	EL_MODULE_COMMAND

	EL_ITERABLE_CONVERTER [EL_FILE_PATH, EL_FILE_MANIFEST_ITEM]
		export
			{NONE} all
		end

	EL_MODULE_LIO

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_template_path, manifest_output_path: EL_FILE_PATH; a_target_dir: EL_DIR_PATH; a_wild_card: STRING)
		-- create list of files in `a_target_dir' conforming to `a_wild_card' and output
		-- XML manifest in `manifest_output_path'
		local
			find_files_cmd: like command.new_find_files
			target_dir: EL_DIR_PATH
		do
			if a_target_dir.is_empty then
				target_dir := manifest_output_path.parent
			else
				target_dir := a_target_dir
			end
			find_files_cmd := command.new_find_files (target_dir, a_wild_card)
			find_files_cmd.set_max_depth (1)
			find_files_cmd.execute
			lio.put_integer_field ("File item count", find_files_cmd.path_list.count)
			lio.put_new_line
			item_list := new_list (find_files_cmd.path_list, agent new_item)
			make_from_template_and_output (a_template_path, manifest_output_path)
		end

feature -- Basic operations

	execute
		do
			lio.put_path_field ("Writing", output_path)
			lio.put_new_line
			serialize
		end

feature {NONE} -- Implementation

	new_item (path: EL_FILE_PATH): EL_FILE_MANIFEST_ITEM
		do
			create Result.make (path)
		end

feature {NONE} -- Evolicity

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["file_list", agent: like item_list do Result := item_list end]
			>>)
		end

feature {NONE} -- Internal attributes

	item_list: EL_ARRAYED_LIST [like new_item]

	wild_card: STRING

feature {NONE} -- Constants

	Template: STRING = "[
		<?xml version = "1.0" encoding = "$encoding_name"?>
		<file-list>
		#foreach $file in $file_list loop
			<file>
				#evaluate ($file.template_name, $file)
			</file>
		#end
		</file-list>
	]"

end
