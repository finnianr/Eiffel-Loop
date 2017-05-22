note
	description: "Summary description for {REPOSITORY_HTML_TEMPLATES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-26 8:48:31 GMT (Tuesday 26th July 2016)"
	revision: "1"

class
	REPOSITORY_HTML_TEMPLATES

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			create config_dir
			create main
			create directory_content
			create eiffel_source
			create site_map_content
			create favicon_markup_path
			Precursor
		end

feature -- Access

	directory_content: EL_FILE_PATH

	eiffel_source: EL_FILE_PATH

	main: EL_FILE_PATH

	site_map_content: EL_FILE_PATH

	favicon_markup_path: EL_FILE_PATH

feature -- Element change

	set_config_dir (a_config_dir: like config_dir)
		do
			config_dir := a_config_dir
		end

feature {NONE} -- Implementation

	config_dir: EL_DIR_PATH

feature {NONE} -- Build from Pyxis

	building_action_table: EL_PROCEDURE_TABLE
		do
			create Result.make (<<
				["@main",						agent set_path_from_node (main)],
				["@eiffel-source",			agent set_path_from_node (eiffel_source)],
				["@site-map-content",		agent set_path_from_node (site_map_content)],
				["@directory-content",		agent set_path_from_node (directory_content)],
				["@favicon-markup", 			agent do favicon_markup_path := config_dir + node.to_string  end]
			>>)
		end

	set_path_from_node (file_path: EL_FILE_PATH)
		do
			file_path.set_path (config_dir + node.to_string)
		end

end
