note
	description: "HTML sitemap page for Eiffel repository"

	

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-09-23 9:24:10 GMT (Friday 23rd September 2016)"
	revision: "2"

class
	REPOSITORY_SITEMAP_PAGE

inherit
	REPOSITORY_HTML_PAGE
		rename
			make as make_page
		redefine
			make_default, getter_function_table
		end

create
	make

feature {NONE} -- Initialization

	make_default
		do
			create source_tree_pages.make (0)
			create stats_cmd.make_default
			Precursor
		end

	make (a_repository: like repository; a_source_tree_pages: like source_tree_pages)
		do
			make_page (a_repository)
			source_tree_pages := a_source_tree_pages
			across repository.tree_list as tree loop
				stats_cmd.manifest.locations.extend (tree.item)
			end
			stats_cmd.execute
		end

feature -- Access

	title: ZSTRING
		do
			Result := repository.name + " " + name
		end

	name: ZSTRING
		do
			Result := "Sitemap"
		end

feature -- Status query

	is_modified: BOOLEAN
		do
			Result := not output_path.exists or else across source_tree_pages as page some page.item.is_modified end
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor
			Result.append_tuples (<<
				["category_list",	agent: like category_list do Result := category_list end],
				["stats", 			agent: like stats_cmd do Result := stats_cmd end]
			>>)
		end

feature {NONE} -- Implementation

	category_list: ARRAYED_LIST [EVOLICITY_CONTEXT]
		local
			category: ZSTRING; list: EL_SORTABLE_ARRAYED_LIST [REPOSITORY_SOURCE_TREE_PAGE]
		do
			create Result.make (source_tree_pages.count // 10 + 1)
			create category.make_empty
			create list.make (0)
			across source_tree_pages as page loop
				if category /~ page.item.category_index_title then
					category := page.item.category_index_title
					list.sort
					create list.make (10)
					Result.extend (create {EVOLICITY_CONTEXT_IMP}.make)
					Result.last.put_variable (list, "page_list")
					Result.last.put_variable (category, "name")
				end
				list.extend (page.item)
			end
		end

	content_template: EL_FILE_PATH
		do
			Result := repository.templates.site_map_content
		end

	source_tree_pages: like repository.new_source_tree_pages

	stats_cmd: EIFFEL_CODEBASE_STATISTICS_COMMAND

feature -- Constants

	Step_count: INTEGER = 0

	relative_file_path: EL_FILE_PATH
		once
			Result := "index.html"
		end
end
