note
	description: "[
		Uncomplicated FireWall user rules found in `/lib/ufw/user.rules'
		See Linux [https://manpages.ubuntu.com/manpages/bionic/man8/ufw.8.html ufw command]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-13 18:33:50 GMT (Thursday 13th February 2025)"
	revision: "1"

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
	make, make_default

feature {NONE} -- Initialization

	make (a_file_path: FILE_PATH)
		do
			make_machine
			create head_lines.make (30)
			create tail_lines.make (50)

			if attached File.plain_text_lines (a_file_path) as lines then
				create denied_access_table.make ((lines.count // 8).max (50))
				do_with_split (agent find_deny_rule, lines, False)
			end
		end

	make_default
		do
			make ("/lib/ufw/user.rules")
		end

feature -- Basic operations

	limit_entries (max_count: INTEGER)
		-- remove older entries to bring number down to `max_count'
		local
			removed_count, i: INTEGER
		do
			if denied_access_table.count > max_count
				and then attached denied_access_table.key_list as ip_list
			then
				removed_count := denied_access_table.count - max_count
				from i := 1 until i > removed_count loop
					denied_access_table.remove (ip_list [i])
					i := i + 1
				end
			end
		ensure
			limited_to_max_count: denied_access_table.count <= max_count
		end

	write (path: EL_FILE_PATH)
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

feature {NONE} -- Strings

	Allow_rule_start: STRING = "### tuple ### allow"

	Deny_rule_start: STRING = "### tuple ### deny"

	End_rules_start: STRING = "### END RULES"

	Port_number_start: STRING = "any "

end