note
	description: "Traffic analysis configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-19 16:16:38 GMT (Wednesday 19th February 2025)"
	revision: "17"

class
	EL_TRAFFIC_ANALYSIS_CONFIG

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			field_included as is_any_field,
			make_from_file as make
		redefine
			on_context_exit
		end

	EL_MODULE_DIRECTORY; EL_MODULE_FILE

create
	make

feature -- Pyxis fields

	crawler_substrings: STRING_8
		-- (on multiple lines separated by ';')

	log_path: FILE_PATH

	match_output_dir: DIR_PATH
		-- location of match-*.txt files for use in EL_URI_FILTER_TABLE

	maximum_uri_digits: INTEGER
		-- maximum number of digits expected in uri. Any more considered a hacking attempt.

	page_list: EL_STRING_8_LIST

	root_names_list: EL_STRING_8_LIST
		-- list of standard files and directory names that must
		-- not be blocked by hacker intercept service

	site_extensions: STRING_8
		-- legitimate extensions used in website
		-- (on multiple lines separated by ';')

feature -- Access

	foreign_extensions: STRING
		do
			if attached (match_output_dir + "match-has_extension.txt") as path then
				if path.exists then
					Result := File.plain_text (path)
				else
					create Result.make_empty
				end
			end
		end

feature {NONE} -- Event handling

	on_context_exit
		do
			if match_output_dir.parent_string (False).starts_with_character ('.') then
				match_output_dir := Directory.Sub_app_configuration #+ match_output_dir
			end
		end

feature {NONE} -- Constants

	Element_node_fields: STRING = "crawler_substrings, site_extensions, page_list, root_names_list"

end