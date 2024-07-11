note
	description: "[
		Cached table of geographic locations for IP address accessible via
		${EL_SHARED_IP_ADDRESS_GEOLOCATION}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-11 15:11:43 GMT (Thursday 11th July 2024)"
	revision: "7"

class
	EL_IP_ADDRESS_GEOLOCATION_TABLE [G -> EL_IP_ADDRESS_COUNTRY create make end]

inherit
	EL_CACHE_TABLE [ZSTRING, NATURAL]
		rename
			new_item as new_location
		redefine
			make
		end

	EL_IP_ADDRESS_INFO_FACTORY [G]

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			Precursor (n)
			create location_table.make (19)
		end

feature -- Basic operations

	try_restore (dir_path: DIR_PATH)
		local
			pair_list: ECD_ARRAYED_TABLE_PAIR_LIST [ZSTRING, NATURAL]
			file_path: FILE_PATH
		do
			file_path := dir_path + stored_data_name
			if file_path.exists then
				create pair_list.make_from_file (file_path)
				accommodate (pair_list.count)
				location_table.accommodate (pair_list.count // 10)
				if attached pair_list as list then
					from list.start until list.after loop
						if attached list.item.value as location then
							location_table.put (location)
							put (location, list.item.key)
						end
						list.forth
					end
				end
			end
		end

	store (dir_path: DIR_PATH)
		local
			pair_list: ECD_ARRAYED_TABLE_PAIR_LIST [ZSTRING, NATURAL]
			file_path: FILE_PATH
		do
			file_path := dir_path + stored_data_name
			create pair_list.make_from_table (Current)
			pair_list.store_as (file_path)
		end

feature {NONE} -- Implementation

	stored_data_name: ZSTRING
		do
			create Result.make_from_general (({G}).name.as_lower)
			Result.remove_head (3) -- EL_
			Result.append_string_general (".dat")
		end

	new_location (ip_number: NATURAL): ZSTRING
		do
			if attached new_info (ip_number) as info then
				location_table.put (info.location)
				Result := location_table.found_item
			end
		end

feature {NONE} -- Internal attributes

	location_table: EL_HASH_SET [ZSTRING]
end