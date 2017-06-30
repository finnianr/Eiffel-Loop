note
	description: "HTML page for Eiffel repository"

	

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-29 11:29:20 GMT (Thursday 29th June 2017)"
	revision: "2"

deferred class
	REPOSITORY_HTML_PAGE

inherit
	EVOLICITY_SERIALIZEABLE
		rename
			Template as Empty_string
		end

	EL_STRING_CONSTANTS

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

	top_dir: STRING
		do
			Result := Directory.relative_parent (step_count)
		end

feature -- Status query

	is_modified: BOOLEAN
		deferred
		end

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
				["top_dir", 				agent top_dir],
				["title", 					agent: like title do Result := XML.escaped (title) end],

				["name", 					agent: like name do Result := XML.escaped (name) end],

				["is_site_map_page",		agent: BOOLEAN_REF do Result := is_site_map_page.to_reference end],

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
