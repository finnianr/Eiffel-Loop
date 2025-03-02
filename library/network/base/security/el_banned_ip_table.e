note
	description: "[
		Table of IP addresses to be banned for a particular kind of port serializeable
		as a configuration file that can be imported into iptables system using command:
		
			sudo iptables-restore --noflush < $rules_path

		**Import Example**
		
			*filter
			:banned-http - [0:0]
			-A banned-http -s 45.148.10.186/32 -p udp -m multiport --dports 80,443 -j DROP
			-A banned-http -s 45.148.10.186/32 -p tcp -m multiport --dports 80,443 -j DROP
			COMMIT

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-02 15:29:44 GMT (Sunday 2nd March 2025)"
	revision: "1"

class
	EL_BANNED_IP_TABLE

inherit
	EL_HASH_SET [NATURAL]
		rename
			make as make_sized,
			has_key as has_address,
			found_item as found_address
		export
			{NONE} all
			{ANY} put, has_address, found_address
		end

	EVOLICITY_SERIALIZEABLE
		export
			{NONE} all
			{ANY} output_path, set_output_path
		undefine
			copy, is_equal
		end

	EL_MODULE_IP_ADDRESS

	EL_SHARED_SERVICE_PORT

create
	make

feature -- Initialization

	make (a_port: NATURAL_16)
		do
			port := a_port
			create recent_additions.make (0)
			make_sized (100)
			make_default
		end

feature -- Access

	port: NATURAL_16

	recent_additions: EL_ARRAYED_LIST [NATURAL]

	related_port: NATURAL_16
		-- optional related port. Eg. 443 (HTTPS) is related to 80 (HTTP)

feature -- Status query

	is_multiport: BOOLEAN
		do
			Result := related_port > 0
		end

feature -- Element change

	set_related_port (a_related_port: NATURAL_16)
		do
			related_port := a_related_port
		end

feature -- Basic operations

	serialize_all
		do
			recent_additions.wipe_out
			serialize
		end

	serialize_recent
		do
			if recent_additions.count > 0 then
				serialize
			end
		end

feature {NONE} -- Implementation

	address_list: EL_ARRAYED_RESULT_LIST [NATURAL, STRING]
		do
			if recent_additions.count > 0 then
				create Result.make (recent_additions, agent IP_address.to_string)
			else
				create Result.make (Current, agent IP_address.to_string)
			end
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
				["address_list", agent: EL_ARRAYED_LIST [STRING] do Result := address_list end],
				["is_multiport", agent: BOOLEAN_REF do Result := is_multiport.to_reference end],
				["protocol",	  agent: STRING do Result := Service_port.name (port) end],
				["port",			  agent: NATURAL_16_REF do Result := port.to_reference end],
				["ports",		  agent get_ports]
			>>)
		end

feature {NONE} -- Constants

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