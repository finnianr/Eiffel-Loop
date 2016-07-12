note
	description: "HTML sitemap page for Eiffel repository"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-07 14:14:52 GMT (Thursday 7th July 2016)"
	revision: "4"

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
			Precursor
		end

	make (a_repository: like repository; a_source_tree_pages: like source_tree_pages)
		do
			make_page (a_repository)
			source_tree_pages := a_source_tree_pages
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

	is_index_page: BOOLEAN
		do
			Result := True
		end

	is_modified: BOOLEAN
		do
			Result := across source_tree_pages as page some page.item.is_modified end
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor
			Result.append_tuples (<<
				["category_list",	agent: like category_list do Result := category_list end]
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
				if category /~ page.item.category then
					category := page.item.category
					list.sort
					create list.make (10)
					Result.extend (create {EVOLICITY_CONTEXT_IMP}.make)
					Result.last.put_variable (list, "page_list")
					Result.last.put_variable (category, "name")
				end
				list.extend (page.item)
			end
		end

	source_tree_pages: like repository.new_source_tree_pages

feature -- Constants

	Step_count: INTEGER = 0

	relative_file_path: EL_FILE_PATH
		once
			Result := "index.html"
		end
end
