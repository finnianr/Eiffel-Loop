note
	description: "[
		Table of IP addresses to be banned for a particular kind of port serializeable
		as a configuration file that can be imported into iptables system using command:
		
			sudo iptables-restore --noflush < $rules_path

		**Import Example**
		
			*filter
			:banned-http - [0:0]
			-A banned-HTTP -s 45.148.10.186/32 -p udp -m multiport --dports 80,443 -j DROP
			-A banned-HTTP -s 45.148.10.186/32 -p tcp -m multiport --dports 80,443 -j DROP
			COMMIT

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-07 8:53:57 GMT (Friday 7th March 2025)"
	revision: "3"

class
	EL_BANNED_IP_TABLES_SET

inherit
	EL_HASH_SET [NATURAL]
		rename
			make as make_sized,
			has_key as has_address,
			put as put_item,
			found_item as found_address
		export
			{NONE} all
			{ANY} count, extendible, has_address, key_tester, found_address
		redefine
			empty_duplicate
		end

	EVOLICITY_SERIALIZEABLE
		export
			{NONE} all
			{ANY} output_path, set_output_path
		undefine
			copy, is_equal
		end

	EL_FILE_OPEN_ROUTINES

	EL_MODULE_IP_ADDRESS

	EL_SHARED_SERVICE_PORT

create
	make, make_empty

feature -- Initialization

	make (a_port: NATURAL_16; a_dir_path: DIR_PATH; n: INTEGER)
		local
			index_slash: INTEGER
		do
			port := a_port; dir_path := a_dir_path
			create recent_additions.make (0)
			make_sized (n)
			if port = 0 then
				make_default
			else
				make_from_file (a_dir_path + (Name_template #$ [port_name]))
			-- read IP addresses from existing rules file
				if output_path.exists then
					across open (output_path, Read) as list loop
						if attached list.item as line then
							index_slash := line.substring_index (once "/32 -p tcp", 1) -- ignore udp
							if index_slash > 0 then
								put_item (parsed_ip_number (line, index_slash))
							end
						end
					end
				end
			end
		end

	make_empty
		do
			make (0, create {DIR_PATH}, 0)
		end

feature -- Access

	port: NATURAL_16

	port_name: STRING
		do
			Result := Service_port.name (port)
		end

	recent_additions: EL_ARRAYED_LIST [NATURAL]

	related_port: NATURAL_16
		-- optional related port. Eg. 443 (HTTPS) is related to 80 (HTTP)

	updates_name: ZSTRING
		do
			Result := Name_template #$ ["new"]
		end

feature -- Status query

	is_multiport: BOOLEAN
		do
			Result := related_port > 0
		end

feature -- Element change

	limit_entries (max_count: INTEGER)
		-- remove older entries to bring number down to `max_count'
		local
			ip_set: EL_HASH_SET [NATURAL]
		do
			if count > max_count and then attached to_list as limited_list then
				limited_list.remove_head (count - max_count)
				create ip_set.make_from (limited_list, False)
				content := ip_set.content
				insertion_marks := ip_set.insertion_marks
				count := max_count; control := 0; position := 0
				found_address := 0
			end
		ensure
			limited_to_max_count: count <= max_count
		end

	put (ip_number: NATURAL)
		do
			put_item (ip_number)
			if inserted then
				recent_additions.extend (ip_number)
			end
		end

	set_related_port (a_related_port: NATURAL_16)
		do
			related_port := a_related_port
		end

feature -- Basic operations

	serialize_all
		do
			save_recent := False
			serialize
		end

	serialize_recent
		do
			if recent_additions.count > 0 and attached output_path.base as previous then
				output_path.set_base (updates_name)
				save_recent := True
				serialize
				output_path.set_base (previous)
				recent_additions.wipe_out
			end
		ensure
			recent_additions_empty: recent_additions.is_empty
		end

feature {NONE} -- Implementation

	address_list: EL_ARRAYED_RESULT_LIST [NATURAL, STRING]
		do
			if save_recent then
				create Result.make (recent_additions, agent IP_address.to_string)
			else
				create Result.make (Current, agent IP_address.to_string)
			end
		end

	empty_duplicate (n: INTEGER): like Current
		do
			create Result.make (port, dir_path, n)
			Result.recent_additions.standard_copy (recent_additions)
		end

	parsed_ip_number (line: STRING; index_slash: INTEGER): NATURAL
		-- Parse IP address from "-A banned-http -s 45.148.10.186/32 -p tcp -m multiport --dports 80,443 -j DROP"
		local
			index_space: INTEGER
		do
			index_space := line.last_index_of (' ', index_slash)
			if index_space > 0 then
				Result := Ip_address.substring_as_number (line, index_space + 1, index_slash - 1)
			end
		ensure
			valid_number: line.has_substring (Ip_address.to_string (Result) + "/32")
		end

feature {NONE} -- Evolicity fields

	get_ports: STRING
		do
			create Result.make (7)
			Result.append_natural_16 (port)
			Result.extend (',')
			Result.append_natural_16 (related_port)
		end

	getter_function_table: like getter_functions
		do
			create Result.make_assignments (<<
				["address_list", agent address_list],
				["is_multiport", agent: BOOLEAN_REF do Result := is_multiport.to_reference end],
				["protocol",	  agent port_name],
				["port",			  agent: NATURAL_16_REF do Result := port.to_reference end],
				["ports",		  agent get_ports]
			>>)
		end

feature {NONE} -- Internal attributes

	save_recent: BOOLEAN

	dir_path: DIR_PATH

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "iptable-%S.rules"
		end

	Template: STRING = "[
		@filter
		:banned-$protocol - [0:0]
		#if $is_multiport then
			#foreach $address in $address_list loop
		-A banned-$protocol -s $address/32 -p tcp -m multiport --dports $ports -j DROP
		-A banned-$protocol -s $address/32 -p udp -m multiport --dports $ports -j DROP
			#end
		#else
			#foreach $address in $address_list loop
		-A banned-$protocol -s $address/32 -p tcp --dport $port -j DROP
		-A banned-$protocol -s $address/32 -p udp --dport $port -j DROP
			#end
		#end
		COMMIT
	]"

end