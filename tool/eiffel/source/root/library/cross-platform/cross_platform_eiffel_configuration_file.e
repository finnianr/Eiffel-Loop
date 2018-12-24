note
	description: "[
		Eiffel configuration file for cross platform interface and implementation classes
		conforming to file wildcards:
			
			*_i.e
			*_imp.e
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-24 16:05:05 GMT (Monday 24th December 2018)"
	revision: "1"

class
	CROSS_PLATFORM_EIFFEL_CONFIGURATION_FILE

inherit
	EIFFEL_CONFIGURATION_FILE
		redefine
			make, new_path_list
		end

	EL_ZSTRING_CONSTANTS
		undefine
			is_equal
		end

	CROSS_PLATFORM_CONSTANTS
		undefine
			is_equal
		end

create
	make

feature {NONE} -- Initialization

	make (a_repository: like repository; ecf: ECF_INFO)
		do
			Precursor (a_repository, ecf)
			create cluster_list.make (source_dir_list.count)
			across source_dir_list as source_dir loop
				cluster_list.extend (create {CROSS_PLATFORM_CLUSTER}.make (source_dir.item, path_list))
			end
		end

feature -- Basic operations

	normalize_imp_classes
		-- normalize location of classes with file-names ending with "_imp.e"
		do
			cluster_list.do_all (agent {CROSS_PLATFORM_CLUSTER}.normalize_locations)
		end

feature {NONE} -- Factory

	new_path_list: EL_FILE_PATH_LIST
		local
			list: EL_FILE_PATH_LIST
		do
			across Wildcards as wildcard loop
				across source_dir_list as path loop
					if attached Result then
						create list.make (path.item, wildcard.item)
						Result.append (list)
					else
						create Result.make (path.item, wildcard.item)
					end
				end
			end
		end

feature {NONE} -- Internal attributes

	cluster_list: EL_ARRAYED_LIST [CROSS_PLATFORM_CLUSTER]

feature {NONE} -- Constants

	Asterisk: ZSTRING
		once
			Result := "*"
		end

	Wildcards: ARRAY [ZSTRING]
		once
			Result := <<
				Asterisk + Interface_ending,
				Asterisk + Implementation_ending
			>>
		end

end
