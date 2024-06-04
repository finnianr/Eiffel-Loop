note
	description: "Eiffel configuration list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-04 11:23:05 GMT (Tuesday 4th June 2024)"
	revision: "16"

class
	EIFFEL_CONFIGURATION_LIST [ECF -> EIFFEL_CONFIGURATION_FILE create make end]

inherit
	EL_SORTABLE_ARRAYED_LIST [EIFFEL_CONFIGURATION_FILE]
		rename
			make as make_list
		export
			{NONE} all
			{ANY} count, is_empty, do_all, extend, order_by
		end

	EL_MODULE_EXCEPTION; EL_MODULE_LIO; EL_MODULE_USER_INPUT

create
	make

feature {NONE} -- Initialization

	make (a_config: like config)
		local
			ecf_path: FILE_PATH; ecf: ECF_INFO; xdoc: EL_XML_DOC_CONTEXT; has_error: BOOLEAN
		do
			config := a_config
			make_list (a_config.ecf_list.count)
			across config.ecf_list as list loop
				ecf := list.item
				ecf_path := config.root_dir + ecf.path
				if ecf_path.exists then
					check_pecf_source (ecf_path)
					create xdoc.make_from_file (ecf_path)
					if xdoc.parse_failed and then attached xdoc.last_exception as last_exception then
						lio.put_path_field ("Failed to parse", ecf_path)
						lio.put_new_line
						last_exception.put_error (lio)
						has_error := True

					elseif ecf.cluster_count (xdoc) = 0 then
						lio.put_path_field ("Configuration %S", ecf_path)
						lio.put_new_line
						lio.put_labeled_string ("Zero nodes found for xpath", ecf.cluster_xpath)
						has_error := True

					elseif xdoc.is_xpath (Xpath_all_classes) then
						extend (create {EIFFEL_LIBRARY_CONFIGURATION_FILE}.make (a_config, ecf, xdoc))

					else
						extend (create {ECF}.make (a_config, ecf, xdoc))
					end
				else
					lio.put_path_field ("Cannot find %S", ecf_path)
					has_error := True
				end
				if has_error then
					lio.put_new_line
					User_input.press_enter
					Exception.raise_developer ("Configuration error", [])
				end
			end
		end

feature -- Access

	sorted_index_page_list: EL_SORTABLE_ARRAYED_LIST [EIFFEL_CONFIGURATION_INDEX_PAGE]
		local
			index_page: EIFFEL_CONFIGURATION_INDEX_PAGE
		do
			create Result.make (count)
			across Current as tree loop
				if config.test_mode then
					create {EIFFEL_CONFIGURATION_INDEX_TEST_PAGE} index_page.make (config, tree.item)
				else
					create index_page.make (config, tree.item)
				end
				Result.extend (index_page)
			end
			Result.ascending_sort
		end

	to_html_page_list: EL_ARRAYED_LIST [REPOSITORY_HTML_PAGE]
		do
			if attached sorted_index_page_list as list then
				create Result.make (list.count + 1)
				Result.extend (create {REPOSITORY_SITEMAP_PAGE}.make (config, list))
				Result.append (list)
			else
				create Result.make (0)
			end
		end

feature -- Basic operations

	get_sync_items (current_set: EL_MEMBER_SET [EL_FILE_SYNC_ITEM])
		do
			across Current as tree loop
				across tree.item.directory_list as directory loop
					across directory.item.class_list as e_class loop
						current_set.put (e_class.item)
					end
				end
			end
		end

	read_class_sources (cpu_percentage: INTEGER)
		local
			parser: EIFFEL_CLASS_PARSER
		do
			create parser.make (cpu_percentage)
			across Current as list loop
				list.item.read_class_source (parser)
			end
			parser.apply_final
		end

	serialize_modified (current_set: EL_MEMBER_SET [EL_FILE_SYNC_ITEM])
		do
			across to_html_page_list as list loop
				if attached list.item as page then
					if page.is_modified then
						page.serialize
					end
					current_set.put (page)
				end
			end
		end

	sink_source_subsitutions
		do
			lio.put_labeled_string (
				"Adding to current_digest", "description ${CLASS_NAME} variable paths and client example paths"
			)
			lio.put_new_line
			across Current as tree loop
				lio.put_labeled_string (tree.item.category, tree.item.name)
				lio.put_new_line
				across tree.item.directory_list as directory loop
					across directory.item.class_list as e_class loop
						e_class.item.sink_source_substitutions
					end
				end
			end
		end

	update_class_sources (cpu_percentage: INTEGER)
		local
			checker: EIFFEL_CLASS_UPDATE_CHECKER
		do
			create checker.make (cpu_percentage)
			across Current as list loop
				list.item.update_source_files (checker)
			end
			checker.apply_final
		end

feature {NONE} -- Implementation

	check_pecf_source (ecf_path: FILE_PATH)
		-- check if pecf format source has been modified
		local
			pecf_path: FILE_PATH; converter: PYXIS_ECF_CONVERTER
		do
			pecf_path := ecf_path.with_new_extension (Extension_pecf)
			if pecf_path.exists and then pecf_path.modification_time > ecf_path.modification_time then
				create converter.make (pecf_path, ecf_path)
				converter.execute
			end
		end

feature {NONE} -- Internal attributes

	config: PUBLISHER_CONFIGURATION

feature {NONE} -- Constants

	Extension_pecf: ZSTRING
		once
			Result := "pecf"
		end

	Xpath_all_classes: STRING = "/system/target/root/@all_classes"

end