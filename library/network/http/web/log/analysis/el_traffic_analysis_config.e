note
	description: "Traffic analysis configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-11 6:41:43 GMT (Tuesday 11th February 2025)"
	revision: "16"

class
	EL_TRAFFIC_ANALYSIS_CONFIG

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			field_included as is_any_field,
			make_from_file as make
		end

create
	make

feature -- Access

	crawler_substrings: STRING_8
		-- (on multiple lines separated by ';')

	site_extensions: STRING_8
		-- legitimate extensions used in website
		-- (on multiple lines separated by ';')

	foreign_extensions: STRING_8
		-- illegitimate extensions foreign to website
		-- (on multiple lines separated by ';')

	log_path: FILE_PATH

	maximum_uri_digits: INTEGER
		-- maximum number of digits expected in uri. Any more considered a hacking attempt.

	page_list: EL_STRING_8_LIST

	root_names_list: EL_STRING_8_LIST
		-- list of standard files and directory names that must
		-- not be blocked by hacker intercept service

	text_output_dir: DIR_PATH
		-- path to save combined output of reports from class `EL_URI_EXTENSION_404_ANALYSIS_COMMAND'
		-- and `EL_URI_STEM_404_ANALYSIS_COMMAND' to cut and paste into hacker intercept configuration

feature {NONE} -- Constants

	Element_node_fields: STRING = "crawler_substrings, foreign_extensions, site_extensions, page_list, root_names_list"

end