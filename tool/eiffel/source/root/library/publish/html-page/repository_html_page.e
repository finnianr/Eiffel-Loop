note
	description: "HTML page for Eiffel repository"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-28 9:23:27 GMT (Sunday 28th March 2021)"
	revision: "8"

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

	make (a_repository: like repository)
		do
			repository := a_repository
			make_from_template_and_output (repository.templates.main, repository.output_dir + relative_file_path)
		end

feature -- Access

	name: ZSTRING
		deferred
		end

	relative_file_path: EL_FILE_PATH
		deferred
		end

	title: ZSTRING
		deferred
		end

feature -- Status query

	is_site_map_page: BOOLEAN
		do
			Result := content_template = repository.templates.site_map_content
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
				["github_url", 			agent: ZSTRING do Result := repository.github_url.to_string end],
				["favicon_markup_path", agent: ZSTRING do Result := repository.templates.favicon_markup_path end],
				["version", 				agent: STRING do Result := repository.version end]
			>>)
		end

feature {NONE} -- Implementation

	content_template: EL_FILE_PATH
		deferred
		end

	step_count: INTEGER
		deferred
		end

feature {NONE} -- Internal attributes

	repository: REPOSITORY_PUBLISHER
end