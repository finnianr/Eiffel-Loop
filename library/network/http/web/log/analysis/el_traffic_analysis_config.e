note
	description: "Traffic analysis configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-03 11:05:43 GMT (Monday 3rd February 2025)"
	revision: "11"

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

	log_path: FILE_PATH

	crawler_substrings: EL_STRING_8_LIST

	page_list: EL_STRING_8_LIST

	text_output_dir: DIR_PATH
		-- path to save combined output of reports from class `EL_URI_EXTENSION_404_ANALYSIS_COMMAND'
		-- and `EL_URI_STEM_404_ANALYSIS_COMMAND' to cut and paste into hacker intercept configuration

feature {NONE} -- Constants

	Element_node_fields: STRING = "crawler_substrings, page_list"

end