note
	description: "Eiffel configuration list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-02 15:12:18 GMT (Sunday 2nd August 2020)"
	revision: "4"

class
	EIFFEL_CONFIGURATION_LIST [G -> EIFFEL_CONFIGURATION_FILE create make end]

inherit
	EL_SORTABLE_ARRAYED_LIST [G]
		rename
			make as make_list
		export
			{NONE} all
			{ANY} count, sort, is_empty, do_all, extend
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
			Result.sort
		end

feature -- Basic operations

	fill_ftp_sync
		do
			across Current as tree loop
				across tree.item.directory_list as directory loop
					across directory.item.class_list as e_class loop
						if e_class.item.html_output_path.exists then
							repository.ftp_sync.extend (e_class.item)
						else
							repository.ftp_sync.force (e_class.item)
						end
					end
				end
			end
		end

	sink_source_subsitutions
		do
			lio.put_labeled_string (
				"Adding to current_digest", "description $source variable paths and client example paths"
			)
			lio.put_new_line
			across Current as tree loop
				lio.put_labeled_string (tree.item.category, tree.item.name)
				lio.put_new_line
				across tree.item.directory_list as directory loop
					across directory.item.class_list as e_class loop
						e_class.item.sink_source_subsitutions
					end
				end
			end
		end

feature {NONE} -- Internal attributes

	repository: REPOSITORY_PUBLISHER

end
