note
	description: "[
		Eiffel configuration file for cross platform interface and implementation classes
		conforming to file wildcards:
			
			*_i.e
			*_imp.e
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-04 8:29:10 GMT (Tuesday 4th June 2024)"
	revision: "14"

class
	CROSS_PLATFORM_EIFFEL_CONFIGURATION_FILE

inherit
	EIFFEL_CONFIGURATION_FILE
		redefine
			make, new_path_list
		end

	CROSS_PLATFORM_CONSTANTS

	EL_ZSTRING_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_config: like config; ecf: ECF_INFO; root: EL_XML_DOC_CONTEXT)
		do
			Precursor (a_config, ecf, root)
			create cluster_list.make (source_dir_list.count)
			across source_dir_list as source_dir loop
				cluster_list.extend (create {CROSS_PLATFORM_CLUSTER}.make (source_dir.item, path_list, ecf))
			end
		end

feature -- Basic operations

	normalize_imp_classes
		-- normalize location of classes with file-names ending with "_imp.e"
		do
			across cluster_list as cluster loop
				if not cluster.item.is_empty then
					cluster.item.normalize_locations
				end
			end
		end

feature {NONE} -- Factory

	new_path_list: EL_FILE_PATH_LIST
		local
			list: EL_FILE_PATH_LIST
		do
			across Wildcards as wildcard loop
				across source_dir_list as path loop
					if attached Result then
						list := OS.file_list (path.item, wildcard.item)
						Result.append (list)
					else
						Result := OS.file_list (path.item, wildcard.item)
					end
				end
			end
		end

feature {NONE} -- Internal attributes

	cluster_list: EL_ARRAYED_LIST [CROSS_PLATFORM_CLUSTER]

feature {NONE} -- Constants

	Override: ZSTRING
		once
			Result := "override"
		end

	Wildcards: ARRAY [ZSTRING]
		once
			Result := <<
				char ('*') + Interface_ending, char ('*') + Implementation_ending
			>>
		end

end