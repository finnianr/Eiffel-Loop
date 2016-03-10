note
	description: "[
		Parses output of nm-tool to get MAC address of ethernet devices
		
		SAMPLE OUTPUT
		
		NetworkManager Tool

		State: connected (global)

		- Device: wlan0  [Auto Rafael] -------------------------------------------------
		  Type:              802.11 WiFi
		  Driver:            b43
		  State:             connected
		  Default:           yes
		  HW Address:        88:53:95:2E:74:99

		  Capabilities:
		    Speed:           24 Mb/s

		  Wireless Properties
		    WEP Encryption:  yes
		    WPA Encryption:  yes
		    WPA2 Encryption: yes

		  Wireless Access Points (* = current AP)
		    eircom33071194:  Infra, EC:43:F6:C3:1B:D8, Freq 2412 MHz, Rate 54 Mb/s, Strength 50 WPA WPA2
		    *Rafael:         Infra, EC:43:F6:C5:EE:30, Freq 2462 MHz, Rate 54 Mb/s, Strength 53 WPA WPA2
		    Vodafone_32FE:   Infra, 00:25:68:CD:8E:5E, Freq 2437 MHz, Rate 54 Mb/s, Strength 24 WEP
		    eircom07150498:  Infra, 5C:F4:AB:5A:F5:54, Freq 2457 MHz, Rate 54 Mb/s, Strength 22 WPA WPA2

		  IPv4 Settings:
		    Address:         192.168.1.4
		    Prefix:          24 (255.255.255.0)
		    Gateway:         192.168.1.254

		    DNS:             192.168.1.254


		- Device: eth0 -----------------------------------------------------------------
		  Type:              Wired
		  Driver:            tg3
		  State:             unavailable
		  Default:           no
		  HW Address:        A8:20:66:50:C4:36

		  Capabilities:
		    Carrier Detect:  yes

		  Wired Properties
		    Carrier:         off

	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_IP_ADAPTER_INFO_COMMAND

inherit
	EL_OS_COMMAND [EL_IP_ADAPTER_INFO_COMMAND_IMPL]
		export
			{NONE} all
		redefine
			Line_processing_enabled, do_with_lines, make_default
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine,
			do_with_lines as parse_lines
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make_default
			--
		do
			make_machine
			create adapters.make
			Precursor
		end

	make
		do
			make_command
			execute
		end

feature -- Access

	adapters: LINKED_LIST [like new_adapter_info]

feature {NONE} -- State handlers

	find_first_device (line: ASTRING)
		do
			if line.has_substring (Field_device) then
				add_device (line)
			end
		end

	add_device (line: ASTRING)
		do
			adapters.extend (new_adapter_info (field_value (line)))
			state := agent find_next_device
		end

	find_next_device (line: ASTRING)
		do
			if line.has_substring (Field_device) then
				add_device (line)

			elseif line.has_substring (Field_type) then
				adapters.last.type := field_value (line)

			elseif line.has_substring (Field_hw_address) then
				adapters.last.address := hardware_address (line)

			end
		end

feature {NONE} -- Implementation

	do_with_lines (lines: EL_FILE_LINE_SOURCE)
			--
		do
			parse_lines (agent find_first_device, lines)
		end

	getter_function_table: like getter_functions
			--
		do
			create Result
		end

	field_value (line: ASTRING): ASTRING
		do
			Result := line.substring (line.index_of (':', 1) + 2, line.count)
			Result.prune_all_trailing ('-')
			Result.left_adjust
			Result.right_adjust
		end

	hardware_address (line: ASTRING): ARRAY [NATURAL_8]
		local
			byte_list: EL_ASTRING_LIST
		do
			create byte_list.make_with_separator (field_value (line), ':', False)
			create Result.make_filled (0, 1, byte_list.count)
			across byte_list as byte loop
				Result [byte.cursor_index] := String.hexadecimal_to_integer (byte.item.as_string_8).to_natural_8
			end
		end

	Line_processing_enabled: BOOLEAN = true

feature {NONE} -- Type definitions

	new_adapter_info (name: ASTRING): TUPLE [name, type: ASTRING; address: like hardware_address]
		do
			create Result
			Result.name := name
			Result.type := ""
			Result.address := create {like hardware_address}.make_empty
		end

feature {NONE} -- Constants

	Field_device: STRING = "Device:"

	Field_type: STRING = "Type:"

	Field_hw_address: STRING = "HW Address:"

end
