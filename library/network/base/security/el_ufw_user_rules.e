note
	description: "[
		Uncomplicated FireWall user rules found in `/lib/ufw/user.rules'
		See Linux [https://manpages.ubuntu.com/manpages/bionic/man8/ufw.8.html ufw command]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-15 17:27:57 GMT (Saturday 15th February 2025)"
	revision: "3"

class
	EL_UFW_USER_RULES

inherit
	ANY

	EL_STRING_STATE_MACHINE [STRING_8]
		rename
			make as make_machine
		undefine
			default_create, is_equal, copy
		end

	EL_MODULE_FILE; EL_MODULE_TUPLE

	EL_MODULE_IP_ADDRESS
		rename
			ip_address as Net_address
		end

	EL_STRING_8_CONSTANTS

	EL_SHARED_SERVICE_PORT

create
	make

feature {NONE} -- Initialization

	make (a_path: FILE_PATH)
		do
			make_machine
			path := a_path
			create head_lines.make (30)
			create tail_lines.make (50)

			if attached File.plain_text_lines (a_path) as lines then
				create denied_access_table.make ((lines.count // 8).max (50))
				do_with_split (agent find_deny_rule, lines, False)
			end
		end

feature -- Access

	path: FILE_PATH
		-- path to store rules in when `store' is called

feature -- Element change

	set_path (a_path: FILE_PATH)
		do
			path := a_path
		end

feature -- Measurement

	ip_address_count: INTEGER
		-- number of IP addresses with denied access rules
		do
			Result := denied_access_table.count
		end

	denied_count (ip_number: NATURAL): INTEGER
		-- number of ports on which `ip_number' is denied access
		local
			b: EL_BIT_ROUTINES
		do
			Result := b.ones_count_32 (denied_access_table [ip_number])
		end

	denied_list (ip_number: NATURAL): EL_STRING_8_LIST
		-- string with list of denied ports
		local
			bitmap: NATURAL_8
		do
			bitmap := denied_access_table [ip_number]
			create Result.make (Port_list.count)
			across Port_list as port loop
				if bitmap.bit_test (bit_index (port.item)) then
					Result.extend (Service_port.name (port.item))
				end
			end
		end

feature -- Basic operations

	display_summary (log: EL_LOGGABLE; heading: READABLE_STRING_GENERAL)
		local
			bit_index_list: EL_ARRAYED_RESULT_LIST [NATURAL_16, INTEGER]
			occurrence_counts: SPECIAL [INTEGER]; i: INTEGER
		do
			create bit_index_list.make (Port_list, agent bit_index)
			create occurrence_counts.make_filled (0, Port_list.count)
			across denied_access_table as table loop
				across bit_index_list as list loop
					if table.item.bit_test (list.item) then
						i := list.item
						occurrence_counts [i] :=  occurrence_counts [i] + 1
					end
				end
			end
			log.put_line (heading)
			across Port_list as list loop
				if attached Service_port.name (list.item) as name then
					log.put_integer_field (name + " count", occurrence_counts [bit_index (list.item)])
					log.put_new_line
				end
			end
		end

	limit_entries (max_count: INTEGER)
		-- remove older entries to bring number down to `max_count'
		do
			if denied_access_table.count > max_count then
				denied_access_table.remove_head (denied_access_table.count - max_count)
			end
		ensure
			limited_to_max_count: denied_access_table.count <= max_count
		end

	put_entry (ip_number: NATURAL; port: NATURAL_16)
		local
			bit_map: NATURAL_8; i: INTEGER
		do
			bit_map := denied_access_table [ip_number]
			i := bit_index (port)
			if i >= 0 then
				denied_access_table [ip_number] := bit_map.set_bit (True, i)
			end
		end

	store
		local
			rules: PLAIN_TEXT_FILE; i: INTEGER
			denied_ports: NATURAL_8
		do
			create rules.make_open_write (path)
			across << head_lines, tail_lines >> as line_list loop
				across line_list.item as line loop
					rules.put_string (line.item)
					if not (line_list.is_last and line.is_last) then
						rules.put_new_line
					end
				end
				if line_list.is_first and then attached Port_list as ports
					and then attached Deny_rule_template as template
				then
					across denied_access_table as table loop
						denied_ports := table.item
						if attached Net_address.to_string (table.key) as ip_address then
							from i := 1 until i > ports.count loop
								if denied_ports.bit_test (i - 1) then
									template.put (Var.address, ip_address)
									template.put (Var.port, ports [i].out)
									rules.put_string (template.substituted)
									rules.put_new_line
									rules.put_new_line
								end
								i := i + 1
							end
						end
					end
				end
			end
			rules.close
		end

feature -- Status query

	is_denied (ip_number: NATURAL; port: NATURAL_16): BOOLEAN
		-- `True' if `ip_number' is denied access on `port'
		local
			i: INTEGER
		do
			i := bit_index (port)
			if i >= 0 then
				Result := denied_access_table [ip_number].bit_test (i)
			end
		end

feature {NONE} -- State handlers

	continue_to_end (line: STRING)
		do
			if line.is_empty then
				tail_lines.extend (Empty_string_8)
			else
				tail_lines.extend (line.twin)
			end
		end

	find_deny_rule (line: STRING)
		local
			index, space_index, offset: INTEGER; port: NATURAL_16
			ip_address: STRING
		do
			if line.starts_with (Deny_rule_start) then
				deny_rule_started := True
				index := line.substring_index (Port_number_start, 1)
				if index.to_boolean then
					offset := Port_number_start.count
					space_index := line.index_of (' ', index + offset)
					if space_index.to_boolean then
						port := line.substring (index + offset, space_index - 1).to_natural_16
						index := line.substring_index (Port_number_start, space_index)
						if index.to_boolean then
							space_index := line.index_of (' ', index + offset)
							if space_index.to_boolean  then
								ip_address := line.substring (index + offset, space_index - 1)
								put_entry (Net_address.to_number (ip_address), port)
							end
						end
					end
				end

			elseif line.starts_with (Allow_rule_start) or else line.starts_with (End_rules_start) then
				deny_rule_started := False
				continue_to_end (line)
				state := agent continue_to_end

			elseif deny_rule_started then
				do_nothing

			elseif line.is_empty then
				head_lines.extend (Empty_string_8)

			else
				head_lines.extend (line.twin)
			end
		end

feature {NONE} -- Implementation

	bit_index (port: NATURAL_16): INTEGER
		do
			Result := Port_list.index_of (port, 1) - 1
		end

feature {NONE} -- Internal attributes

	denied_access_table: EL_HASH_TABLE [NATURAL_8, NATURAL]
		-- map IP number key to bitmap item of common ports defined by `bit_index'

	deny_rule_started: BOOLEAN

	head_lines: EL_STRING_8_LIST

	tail_lines: EL_STRING_8_LIST

feature {NONE} -- Constants

	Deny_rule_template: EL_TEMPLATE [STRING]
		once
			create Result.make ("[
				### tuple ### deny any $port 0.0.0.0/0 any $address in
				-A ufw-user-input -p tcp --dport $port -s $address -j DROP
				-A ufw-user-input -p udp --dport $port -s $address -j DROP
			]")
		end

	Port_list: ARRAYED_LIST [NATURAL_16]
		once
			create Result.make_from_array (<<
				Service_port.HTTP, Service_port.HTTPS, Service_port.SMTP, Service_port.SSH
			>>)
		end

	Var: TUPLE [address, port: STRING]
		once
			create Result
			Tuple.fill (Result, "address, port")
		end

feature {NONE} -- UFW rule identifiers

	Allow_rule_start: STRING = "### tuple ### allow"

	Deny_rule_start: STRING = "### tuple ### deny"

	End_rules_start: STRING = "### END RULES"

	Port_number_start: STRING = "any "

end