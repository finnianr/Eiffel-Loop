note
	description: "[
		Uncomplicated FireWall user rules found in `/lib/ufw/user.rules'
		See Linux [https://manpages.ubuntu.com/manpages/bionic/man8/ufw.8.html ufw command]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-04 8:12:52 GMT (Tuesday 4th March 2025)"
	revision: "5"

class
	EL_UFW_USER_RULES

inherit
	ANY

	EL_STRING_STATE_MACHINE [STRING_8]
		rename
			make as make_default
		undefine
			default_create, is_equal, copy
		redefine
			make_default
		end

	EL_MODULE_FILE; EL_MODULE_TUPLE; EL_MODULE_USER_INPUT

	EL_MODULE_IP_ADDRESS
		rename
			ip_address as Net_address
		end

	EL_STRING_8_CONSTANTS

	EL_SHARED_SERVICE_PORT

create
	make, make_default

feature {NONE} -- Initialization

	make (a_path: FILE_PATH)
		do
			make_default
			path := a_path
			if a_path.exists and then attached File.plain_text_lines (a_path) as lines then
				denied_access_table.accommodate ((lines.count // 8).max (50))
				do_with_split (agent find_deny_rule, lines, False)
			end
		end

	make_default
		do
			Precursor
			create path
			create head_lines.make (30)
			create tail_lines.make (50)
			create denied_access_table.make (Port_list, 0)
		end

feature -- Access

	denied_access_table: EL_PORT_BIT_MAP_TABLE
		-- map IP number key to bitmap item of common ports defined by `bit_index'

	path: FILE_PATH
		-- path to store rules in when `store' is called

feature -- Element change

	set_path (a_path: FILE_PATH)
		do
			path := a_path
		end

feature -- Measurement

	denied_count (ip_number: NATURAL): INTEGER
		-- number of ports on which `ip_number' is denied access
		do
			Result := denied_access_table.port_count (ip_number)
		end

	ip_address_count: INTEGER
		-- number of IP addresses with denied access rules
		do
			Result := denied_access_table.count
		end

feature -- Basic operations

	store
		local
			rules: PLAIN_TEXT_FILE; i: INTEGER; denied_ports: NATURAL_8
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
		do
			Result := denied_access_table.has_port (ip_number, port)
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
								denied_access_table.put_entry (Net_address.to_number (ip_address), port)
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

feature {NONE} -- Internal attributes

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

	Port_list: ARRAY [NATURAL_16]
		once
			Result := << Service_port.HTTPS, Service_port.HTTP, Service_port.SMTP, Service_port.SSH >>
		ensure
			same_order_as_ufw: Result [1] = Service_port.HTTPS
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