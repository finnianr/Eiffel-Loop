note
	description: "Lookup a bitmap of up to 8 ports from a 32-bit IP address number"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-04 8:12:23 GMT (Tuesday 4th March 2025)"
	revision: "1"

class
	EL_PORT_BIT_MAP_TABLE

inherit
	EL_HASH_TABLE [NATURAL_8, NATURAL]
		rename
			make as make_sized
		redefine
			empty_duplicate
		end

	EL_SHARED_SERVICE_PORT

create
	make

feature {NONE} -- Initialization

	make (ports: ARRAY [NATURAL_16]; n: INTEGER)
		require
			maximum_ports: ports.count <= 8
		do
			make_sized (n)
			create port_list.make_from_array (ports)
		end

feature -- Access

	multi_port_map_list: EL_ARRAYED_MAP_LIST [NATURAL, STRING]
		-- map list of `ip_number' to comma separated string of port names
		-- for all entries that have more than one port
		local
			b: EL_BIT_ROUTINES
		do
			create Result.make (50)
			across Current as table loop
				if b.ones_count_32 (table.item) > 1 then
					Result.extend (table.key, new_port_name_list (table.item).joined_with_string (", "))
				end
			end
		end

	name_list (ip_number: NATURAL): EL_STRING_8_LIST
		-- list of port names for `ip_number'
		do
			if has_key (ip_number) then
				Result := new_port_name_list (found_item)
			else
				create Result.make_empty
			end
		end

feature -- Status query

	has_port (ip_number: NATURAL; port: NATURAL_16): BOOLEAN
		-- `True' if `ip_number' is mapped to `port'
		require
			valid_port (port)
		local
			i: INTEGER
		do
			i := bit_index (port)
			if i >= 0 then
				Result := item (ip_number).bit_test (i)
			end
		end

feature -- Contract Support

	valid_port (port: NATURAL_16): BOOLEAN
		do
			Result := port_list.has (port)
		end

feature -- Measurement

	port_count (ip_number: NATURAL): INTEGER
		-- number of ports for `ip_number'
		local
			b: EL_BIT_ROUTINES
		do
			Result := b.ones_count_32 (item (ip_number))
		end

feature -- Element change

	append (ip_table_set: EL_BANNED_IP_TABLES_SET)
		do
			across ip_table_set as ip_number loop
				put_entry (ip_number.item, ip_table_set.port)
			end
		end

	limit_entries (max_count: INTEGER)
		-- remove older entries to bring number down to `max_count'
		do
			if count > max_count then
				remove_head (count - max_count)
			end
		ensure
			limited_to_max_count: count <= max_count
		end

	put_entry (ip_number: NATURAL; port: NATURAL_16)
		require
			valid_port (port)
		local
			bit_map: NATURAL_8; i: INTEGER
		do
			bit_map := item (ip_number)
			i := bit_index (port)
			if i >= 0 then
				force (bit_map.set_bit (True, i), ip_number)
			end
		end

feature -- Basic operations

	display_summary (log: EL_LOGGABLE; heading: READABLE_STRING_GENERAL)
		local
			bit_index_list: EL_ARRAYED_RESULT_LIST [NATURAL_16, INTEGER]
			occurrence_counts: SPECIAL [INTEGER]; i: INTEGER
		do
			create bit_index_list.make (port_list, agent bit_index)
			create occurrence_counts.make_filled (0, Port_list.count)
			across Current as table loop
				across bit_index_list as list loop
					if table.item.bit_test (list.item) then
						i := list.item
						occurrence_counts [i] :=  occurrence_counts [i] + 1
					end
				end
			end
			log.put_line (heading)
			across port_list as list loop
				if attached Service_port.name (list.item) as name then
					log.put_integer_field (name + " count", occurrence_counts [bit_index (list.item)])
					log.put_new_line
				end
			end
		end

feature {NONE} -- Implementation

	bit_index (port: NATURAL_16): INTEGER
		do
			Result := port_list.index_of (port, 1) - 1
		end

	empty_duplicate (n: INTEGER): like Current
		do
			create Result.make (port_list.to_array, n)
		end

	new_port_name_list (bitmap: NATURAL_8): EL_STRING_8_LIST
		-- list of denied ports for `bitmap'

		do
			create Result.make (Port_list.count)
			across Port_list as port loop
				if bitmap.bit_test (bit_index (port.item)) then
					Result.extend (Service_port.name (port.item))
				end
			end
		end

feature {NONE} -- Internal attributes

	port_list: ARRAYED_LIST [NATURAL_16]

end