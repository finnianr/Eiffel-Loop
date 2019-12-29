note
	description: "[
		Parse terse output of [https://developer.gnome.org/NetworkManager/stable/nmcli.html nmcli tool]
		to get list of network adapter devices: [$source EL_ADAPTER_DEVICE]
		
			nmcli --terse dev list | grep --color=never GENERAL
		
		**Sample Output**

			GENERAL.DEVICE:84:8E:DF:AD:7F:3C
			GENERAL.TYPE:bluetooth
			GENERAL.VENDOR:--
			GENERAL.PRODUCT:--
			GENERAL.DRIVER:bluez
			GENERAL.DRIVER-VERSION:
			GENERAL.FIRMWARE-VERSION:
			GENERAL.HWADDR:(unknown)
			GENERAL.STATE:30 (disconnected)
			GENERAL.REASON:0 (No reason given)
			GENERAL.UDI:/org/bluez/948/hci0/dev_84_8E_DF_AD_7F_3C
			GENERAL.IP-IFACE:
			GENERAL.NM-MANAGED:yes
			GENERAL.AUTOCONNECT:yes
			GENERAL.FIRMWARE-MISSING:no
			GENERAL.CONNECTION:not connected
			GENERAL.DEVICE:wlan0
			GENERAL.TYPE:802-11-wireless
			GENERAL.VENDOR:Broadcom Corporation
			GENERAL.PRODUCT:AirPort Extreme
			GENERAL.DRIVER:wl
			GENERAL.DRIVER-VERSION:6.30.223.248 (r487574)
			GENERAL.FIRMWARE-VERSION:
			GENERAL.HWADDR:88:53:95:2E:74:99
			GENERAL.STATE:100 (connected)
			GENERAL.REASON:0 (No reason given)
			GENERAL.UDI:/sys/devices/pci0000:00/0000:00:1c.1/0000:02:00.0/net/wlan0
			GENERAL.IP-IFACE:wlan0
			GENERAL.NM-MANAGED:yes
			GENERAL.AUTOCONNECT:yes
			GENERAL.FIRMWARE-MISSING:no
			GENERAL.CONNECTION:/org/freedesktop/NetworkManager/ActiveConnection/0

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-29 14:59:10 GMT (Sunday 29th December 2019)"
	revision: "5"

deferred class
	EL_IP_ADAPTER_INFO_COMMAND_I

inherit
	EL_CAPTURED_OS_COMMAND_I
		export
			{NONE} all
		redefine
			do_with_lines, make_default
		end

	EL_MODULE_COLON_FIELD

feature {NONE} -- Initialization

	make
		do
			make_default
			execute
		end

	make_default
			--
		do
			create device.make_default
			create adapter_list.make (3)
			Precursor
		end

feature -- Access

	adapter_list: EL_ARRAYED_LIST [EL_ADAPTER_DEVICE]

feature {NONE} -- Implementation

	do_with_lines (lines: like adjusted_lines)
			--
		local
			table: like Field_actions
			do_with_value: PROCEDURE [ZSTRING]
		do
			table := Field_actions
			from lines.start until lines.after loop
				if table.has_key (field_name (lines.item)) then
					do_with_value := table.found_item
					do_with_value.set_target (Current)
					do_with_value (Colon_field.value (lines.item))
				end
				lines.forth
			end
		end

	field_name (line: ZSTRING): STRING
		do
			Result := Colon_field.name (line)
			Result.remove_head (General_dot_count)
		end

	getter_function_table: like getter_functions
			--
		do
			create Result
		end

feature {NONE} -- Field actions

	create_device (name: ZSTRING)
		do
			create device.make (name)
			try_set_adapter_address (name) -- For bluetooth `name' maybe a hardware address
		end

	extend_list (value: ZSTRING)
		do
			adapter_list.extend (device)
		end

	set_description (value: ZSTRING)
		do
			device.set_description (value)
		end

	set_type (value: ZSTRING)
		do
			device.set_type (value)
		end

	try_set_adapter_address (address_candidate: ZSTRING)
		do
			if device.valid_hardware_address (address_candidate) then
				device.set_address_from_string (address_candidate)
			end
		end

feature {NONE} -- Internal attributes

	device: EL_ADAPTER_DEVICE

feature {NONE} -- Constants

	Field_actions: EL_HASH_TABLE [PROCEDURE [ZSTRING], STRING]
		once
			create Result.make (<<
				["DEVICE",		agent create_device],
				["TYPE",			agent set_type],
				["PRODUCT",		agent set_description],
				["HWADDR",		agent try_set_adapter_address],
				["CONNECTION",	agent extend_list]
			>>)
		end

	General_dot_count: INTEGER = 8
		-- Length of "GENERAL."

end
