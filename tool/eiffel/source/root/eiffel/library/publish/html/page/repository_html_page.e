note
	description: "HTML page for Eiffel repository"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-04 8:10:50 GMT (Tuesday 4th June 2024)"
	revision: "12"

deferred class
	REPOSITORY_HTML_PAGE

inherit
	EL_FILE_SYNC_ITEM
		rename
			make as make_sync_item
		undefine
			is_equal
		end

	EVOLICITY_SERIALIZEABLE
		rename
			Template as Empty_string
		end

	EL_ZSTRING_CONSTANTS

	EL_MODULE_XML

	EL_MODULE_DIRECTORY

feature {NONE} -- Initialization

	make (a_config: like config)
		do
			config := a_config
			make_from_template_and_output (config.templates.main, config.output_dir + relative_file_path)
		end

feature -- Access

	name: ZSTRING
		deferred
		end

	relative_file_path: FILE_PATH
		deferred
		end

	title: ZSTRING
		deferred
		end

feature -- Status query

	is_site_map_page: BOOLEAN
		do
			Result := content_template = config.templates.site_map_content
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["content_template",		agent content_template],
				["title", 					agent: like title do Result := XML.escaped (title) end],
				["name", 					agent: like name do Result := XML.escaped (name) end],
				["is_site_map_page",		agent: BOOLEAN_REF do Result := is_site_map_page.to_reference end],

				["top_dir", 				agent: ZSTRING do Result := Directory.relative_parent (step_count) end],
				["relative_file_path", 	agent: ZSTRING do Result := relative_file_path end],
				["github_url", 			agent: ZSTRING do Result := config.github_url.to_string end],
				["favicon_markup_path", agent: ZSTRING do Result := config.templates.favicon_markup_path end],
				["version", 				agent: STRING do Result := config.version end]
			>>)
		end

feature {NONE} -- Implementation

	content_template: FILE_PATH
		deferred
		end

	step_count: INTEGER
		deferred
		end

feature {NONE} -- Internal attributes

	config: PUBLISHER_CONFIGURATION

	version: STRING

end