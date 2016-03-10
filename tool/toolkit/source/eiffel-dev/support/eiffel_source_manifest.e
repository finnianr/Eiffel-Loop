note
	description: "Summary description for {EL_EIFFEL_SOURCE_MANIFEST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-10 10:45:05 GMT (Saturday 10th January 2015)"
	revision: "5"

class
	EIFFEL_SOURCE_MANIFEST

inherit
	EL_BUILDABLE_FROM_PYXIS
		redefine
			make_default, building_action_table
		end

	EL_MODULE_LOG

	EL_STRING_CONSTANTS

create
	make_default, make_from_file, make_from_string

feature {NONE} -- Initialization

	make_default
			--
		do
			create locations.make (10)
			Precursor
		end

feature -- Access

	file_list: EL_FILE_PATH_LIST
		local
			file_count: INTEGER
			l_file_list: EL_FILE_PATH_LIST
		do
			across locations as location loop
				file_count := file_count + location.item.file_list.count
			end
			create Result.make_with_count (file_count)
			across locations as location loop
				l_file_list := location.item.file_list
				from l_file_list.start until l_file_list.after loop
					Result.extend (l_file_list.path)
					l_file_list.forth
				end
			end
		end

	sorted_file_list: like file_list
		do
			Result := file_list
			Result.sort
		end

	sorted_locations: EL_SORTABLE_ARRAYED_LIST [EIFFEL_SOURCE_LOCATION]
		do
			create Result.make_from_array (locations.to_array)
			Result.sort
		end

	locations: EL_ARRAYED_LIST [EIFFEL_SOURCE_LOCATION]

feature {NONE} -- Build from Pyxis

	extend_locations
			--
		do
			locations.extend (create {EIFFEL_SOURCE_LOCATION}.make)
			set_next_context (locations.last)
		end

	building_action_table: like Type_building_actions
			-- Nodes relative to root element: bix
		do
			create Result.make (<<
				["location", agent extend_locations]
			>>)
		end

	Root_node_name: STRING = "manifest"

end
