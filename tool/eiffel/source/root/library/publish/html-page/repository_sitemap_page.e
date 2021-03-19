note
	description: "HTML sitemap page for Eiffel repository"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-18 18:03:07 GMT (Thursday 18th March 2021)"
	revision: "9"

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

	make (a_repository: like repository; a_ecf_pages: like ecf_pages)
		local
			class_set: EL_HASH_TABLE [EIFFEL_CLASS, EL_FILE_PATH]
		do
			make_page (a_repository)
			ecf_pages := a_repository.ecf_list.sorted_index_page_list
			create class_set.make_equal (2000)
			across repository.ecf_list as ecf loop
				across ecf.item.directory_list as dir loop
					across dir.item.class_list as l_class loop
						if not class_set.has (l_class.item.source_path) then
							stats_cmd.add_class_stats (l_class.item)
							class_set.extend (l_class.item, l_class.item.source_path)
						end
					end
				end
			end
			make_sync_item (output_path)
		end

	make_default
		do
			ecf_pages := Default_ecf_pages
			create stats_cmd.make_default
			Precursor
		end

feature -- Access

	name: ZSTRING
		do
			Result := "Sitemap"
		end

	title: ZSTRING
		do
			Result := repository.name + " " + name
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor + 	["category_list",	agent: like category_list do Result := category_list end] +
											["stats", 			agent: like stats_cmd do Result := stats_cmd end]
		end

feature {NONE} -- Implementation

	category_list: ARRAYED_LIST [EVOLICITY_CONTEXT]
		local
			category: ZSTRING; list: EL_SORTABLE_ARRAYED_LIST [EIFFEL_CONFIGURATION_INDEX_PAGE]
		do
			create Result.make (ecf_pages.count // 10 + 1)
			create category.make_empty
			create list.make (0)
			across ecf_pages as page loop
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

	sink_content (crc: like crc_generator)
		do
			crc.add_file (template_path)
			across ecf_pages as page loop
				crc.add_natural (page.item.current_digest)
			end
		end

feature {NONE} -- Initialization

	ecf_pages: LIST [EIFFEL_CONFIGURATION_INDEX_PAGE]

	stats_cmd: CODEBASE_STATISTICS_COMMAND

feature -- Constants

	Default_ecf_pages: ARRAYED_LIST [EIFFEL_CONFIGURATION_INDEX_PAGE]
		once
			create Result.make (0)
		end

	Relative_file_path: EL_FILE_PATH
		once
			Result := "index.html"
		end

	Step_count: INTEGER = 0

end