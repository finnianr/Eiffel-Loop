note
	description: "Unix implementation of ${EL_NETWORK_DEVICE_LIST_I}"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-06 8:53:06 GMT (Monday 6th November 2023)"
	revision: "21"

class
	EL_NETWORK_DEVICE_LIST_IMP

inherit
	EL_NETWORK_DEVICE_LIST_I
		export
			{NONE} all
		end

	EL_UNIX_IMPLEMENTATION

	EL_CAPTURED_OS_COMMAND_IMP
		rename
			make_default as make
		export
			{NONE} all
		undefine
			copy, is_equal
		redefine
			do_with_lines, make, is_valid_platform
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_list (10)
			Precursor
			execute
		end


feature {NONE} -- Status query

	is_valid_platform: BOOLEAN
		do
			Result := {PLATFORM}.is_unix
		end

feature {NONE} -- Implementation

	do_with_lines (lines: like new_output_lines)
			--
		local
			name: STRING; field: EL_COLON_FIELD_ROUTINES
		do
			from lines.start until lines.after loop
				if lines.item.starts_with (General_dot) then
					name := new_field_name (lines.item)
					if name ~ Field_device then
						extend (create {EL_NETWORK_DEVICE_IMP}.make)
					end
					if attached {EL_NETWORK_DEVICE_IMP} last as device then
						device.set_field (name, field.value (lines.item))
					end
				end
				lines.forth
			end
			do_all (agent {EL_NETWORK_DEVICE_I}.set_type_enum_id)
		end

	new_field_name (line: ZSTRING): STRING
		require
			starts_with_general: line.starts_with (General_dot)
		local
			field: EL_COLON_FIELD_ROUTINES
		do
			Result := field.name (line)
			Result.remove_head (General_dot.count)
		end

feature {NONE} -- Constants

	Field_device: STRING = "DEVICE"

	General_dot: ZSTRING
		once
			Result := "GENERAL."
		end

feature {NONE} -- Constants

	Template: STRING = "nmcli --terse --fields GENERAL dev list"

note

	notes: "[
		Parses terse output of [https://developer.gnome.org/NetworkManager/stable/nmcli.html nmcli tool]
		to get list of network adapter devices ${EL_NETWORK_DEVICE_I}.

			nmcli --terse --fields GENERAL dev list

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


end