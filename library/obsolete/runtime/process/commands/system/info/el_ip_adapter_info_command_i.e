note
	description: "[
		Parses output of nm-tool to get MAC address of ethernet devices
		
		**NetworkManager Tool Output**

			State: connected (global)

			Device: wlan0  [Auto Rafael] -------------------------------------------------
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

			Device: eth0 -----------------------------------------------------------------
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

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-02 13:11:28 GMT (Monday 2nd April 2018)"
	revision: "4"

deferred class
	EL_IP_ADAPTER_INFO_COMMAND_I

inherit
	EL_CAPTURED_OS_COMMAND_I
		export
			{NONE} all
		redefine
			do_with_lines, make_default
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine,
			do_with_lines as parse_lines
		end

	EL_MODULE_HEXADECIMAL

feature {NONE} -- Initialization

	make_default
			--
		do
			make_machine
			create adapters.make (3)
			Precursor
		end

	make
		do
			make_default
			execute
		end

feature -- Access

	adapters: EL_ARRAYED_LIST [EL_ADAPTER_DEVICE]

feature {NONE} -- State handlers

	find_first_device (line: ZSTRING)
		do
			if line.has_substring (Field_device) then
				add_device (line)
			end
		end

	add_device (line: ZSTRING)
		local
			name: ZSTRING
		do
			name := field_value (line)
			if name.has ('[') then
				name.keep_head (name.index_of ('[', 1) - 1)
				name.right_adjust
			end
			adapters.extend (create {EL_ADAPTER_DEVICE}.make (name))
			state := agent find_next_device
		end

	find_next_device (line: ZSTRING)
		do
			if line.has_substring (Field_device) then
				add_device (line)

			elseif line.has_substring (Field_type) then
				adapters.last.set_type (field_value (line))

			elseif line.has_substring (Field_hw_address) then
				adapters.last.set_address (field_value (line))

			end
		end

feature {NONE} -- Implementation

	do_with_lines (lines: like adjusted_lines)
			--
		do
			parse_lines (agent find_first_device, lines)
		end

	getter_function_table: like getter_functions
			--
		do
			create Result
		end

	field_value (line: ZSTRING): ZSTRING
		do
			Result := line.substring_end (line.index_of (':', 1) + 2)
			Result.prune_all_trailing ('-')
			Result.left_adjust
			Result.right_adjust
		end

	hardware_address (line: ZSTRING): ARRAY [NATURAL_8]
		local
			byte_list: EL_ZSTRING_LIST
		do
			create byte_list.make_with_separator (field_value (line), ':', False)
			create Result.make_filled (0, 1, byte_list.count)
			across byte_list as byte loop
				Result [byte.cursor_index] := Hexadecimal.to_integer (byte.item).to_natural_8
			end
		end

feature {NONE} -- Constants

	Field_device: ZSTRING
		once
			Result := "Device:"
		end

	Field_type: ZSTRING
		once
			Result := "Type:"
		end

	Field_hw_address: ZSTRING
		once
			Result := "HW Address:"
		end

end
