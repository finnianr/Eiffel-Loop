note
	description: "Eiffel configuration list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "13"

class
	EIFFEL_CONFIGURATION_LIST [G -> EIFFEL_CONFIGURATION_FILE create make end]

inherit
	EL_SORTABLE_ARRAYED_LIST [G]
		rename
			make as make_list
		export
			{NONE} all
			{ANY} count, ascending_sort, is_empty, do_all, extend
		end

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make (a_repository: like repository)
		do
			repository := a_repository
			make_list (40)
		end

feature -- Access

	to_html_page_list: EL_ARRAYED_LIST [REPOSITORY_HTML_PAGE]
		local
			list: LIST [EIFFEL_CONFIGURATION_INDEX_PAGE]
		do
			list := sorted_index_page_list
			create Result.make (list.count + 1)
			Result.extend (create {REPOSITORY_SITEMAP_PAGE}.make (repository, list))
			Result.append (list)
		end

	sorted_index_page_list: EL_SORTABLE_ARRAYED_LIST [EIFFEL_CONFIGURATION_INDEX_PAGE]
		do
			create Result.make (count)
			across Current as tree loop
				Result.extend (create {EIFFEL_CONFIGURATION_INDEX_PAGE}.make (repository, tree.item))
			end
			Result.ascending_sort
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

feature {NONE} -- Internal attributes

	repository: REPOSITORY_PUBLISHER

end