note
	description: "[
		Command to create an XML file manifest of a target directory using either the default Evolicity template
		or an optional external Evolicity template. See class [$source EVOLICITY_SERIALIZEABLE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-11 17:34:25 GMT (Tuesday 11th January 2022)"
	revision: "5"

class
	EL_FILE_MANIFEST_COMMAND

inherit
	EL_COMMAND

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_TRACK

	EL_MODULE_LIO

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_template_path, manifest_output_path: FILE_PATH; a_target_dir: DIR_PATH; extension: STRING)
		-- create list of files in `a_target_dir' conforming to `extension' and output
		-- XML manifest in `manifest_output_path'
		local
			sorted_path_list: like File_system.files
			target_dir: DIR_PATH
		do
			if a_target_dir.is_empty then
				target_dir := manifest_output_path.parent
			else
				target_dir := a_target_dir
			end
			sorted_path_list := File_system.files_with_extension (target_dir, extension, False)
			sorted_path_list.sort
			lio.put_integer_field ("File item count", sorted_path_list.count)
			lio.put_new_line

			create manifest.make_from_template_and_output (a_template_path, manifest_output_path)
			manifest.append_files (sorted_path_list)
		end

feature -- Basic operations

	execute
		do
			if manifest.is_modified then
				lio.put_path_field ("Writing", manifest.output_path)
				lio.put_new_line
				manifest.serialize
			else
				lio.put_path_field ("No change for", manifest.output_path)
				lio.put_new_line
			end
		end

feature -- Access

	manifest: EL_FILE_MANIFEST_LIST

end