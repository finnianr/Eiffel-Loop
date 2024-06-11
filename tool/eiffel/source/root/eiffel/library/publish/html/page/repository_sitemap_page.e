note
	description: "HTML sitemap page for Eiffel repository"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-11 10:33:13 GMT (Tuesday 11th June 2024)"
	revision: "24"

class
	REPOSITORY_SITEMAP_PAGE

inherit
	REPOSITORY_HTML_PAGE
		rename
			make as make_page,
			Var as Standard_var
		redefine
			make_default, getter_function_table, sink_content
		end

	EL_THREAD_ACCESS [CODEBASE_METRICS]

	EL_MODULE_TUPLE

create
	make

feature {NONE} -- Initialization

	make (a_config: like config; a_ecf_pages: like ecf_pages)
		do
			make_page (a_config)
			ecf_pages := a_ecf_pages
			make_sync_item (
				config.output_dir, config.ftp_host, output_path.relative_path (config.output_dir), 0
			)
		end

	make_default
		do
			ecf_pages := Default_ecf_pages
			create metrics.make
			Precursor
		end

feature -- Access

	metrics: CODEBASE_METRICS

	name: ZSTRING
		do
			Result := "Sitemap"
		end

	title: ZSTRING
		do
			Result := config.name + " " + name
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor +
				["category_list",	agent: like category_list do Result := category_list end] +
				["metrics", 		agent: like metrics do Result := metrics end]
		end

feature {NONE} -- Implementation

	category_list: ARRAYED_LIST [EVOLICITY_TUPLE_CONTEXT]
		local
			category: ZSTRING; list: EL_SORTABLE_ARRAYED_LIST [EIFFEL_CONFIGURATION_INDEX_PAGE]
			context: EVOLICITY_TUPLE_CONTEXT
		do
			create Result.make (ecf_pages.count // 10 + 1)
			create category.make_empty
			create list.make (0)
			across ecf_pages as page loop
				if category /~ page.item.category_index_title then
					category := page.item.category_index_title
					list.ascending_sort
					create list.make (10)
					create context.make ([page.item.category_id, category, list], once "id, name, page_list")
					Result.extend (context)
				end
				list.extend (page.item)
			end
		end

	content_template: FILE_PATH
		do
			Result := config.templates.site_map_content
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

feature -- Constants

	Default_ecf_pages: ARRAYED_LIST [EIFFEL_CONFIGURATION_INDEX_PAGE]
		once
			create Result.make (0)
		end

	Relative_file_path: FILE_PATH
		once
			Result := "index.html"
		end

	Step_count: INTEGER = 0

end