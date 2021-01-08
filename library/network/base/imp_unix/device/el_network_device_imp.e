note
	description: "[
		Adapter device with fields based on `GENERAL.x' from the output of following command: 
		
		[https://developer.gnome.org/NetworkManager/stable/nmcli.html nmcli --terse --fields GENERAL dev list]
	]"
	notes: "[
		**Example USB wireless adapter**
		
			GENERAL.DEVICE:wlan1
			GENERAL.TYPE:802-11-wireless
			GENERAL.VENDOR:Ralink
			GENERAL.PRODUCT:802.11 n WLAN
			GENERAL.DRIVER:rt2800usb
			GENERAL.DRIVER-VERSION:3.13.0-141-generic
			GENERAL.FIRMWARE-VERSION:N/A
			GENERAL.HWADDR:7C:DD:90:65:98:47
			GENERAL.STATE:30 (disconnected)
			GENERAL.REASON:42 (The supplicant is now available)
			GENERAL.UDI:/sys/devices/pci0000:00/0000:00:14.0/usb3/3-3/3-3:1.0/net/wlan1
			GENERAL.IP-IFACE:
			GENERAL.NM-MANAGED:yes
			GENERAL.AUTOCONNECT:yes
			GENERAL.FIRMWARE-MISSING:no
			GENERAL.CONNECTION:not connected
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-08 16:00:24 GMT (Friday 8th January 2021)"
	revision: "4"

class
	EL_NETWORK_DEVICE_IMP

inherit
	EL_NETWORK_DEVICE_I

	EL_REFLECTIVELY_SETTABLE
		rename
			make_default as make,
			field_included as is_any_field,
			export_name as export_default,
			import_name as from_kebab_case_upper
		end

	EL_SETTABLE_FROM_STRING_8
		rename
			make_default as make
		end

	EL_MODULE_HEXADECIMAL

	EL_MODULE_BUFFER

	EL_MODULE_BUFFER_8

create
	make

feature -- Access

	address: ARRAY [NATURAL_8]
		do
			across << hwaddr, device, Default_address >> as candidate until attached Result loop
				if valid_hardware_address (candidate.item) then
					Result := new_hardware_address (candidate.item)
				end
			end
		end

	description: ZSTRING
		do
			Result := buffer.empty
			across << vendor, product, type >> as list loop
				if not valid_hardware_address (list.item) then
					Result.append_string_general (list.item); Result.prune_all_trailing ('-')
				end
				if not Result.is_empty and not list.is_last then
					Result.append_character (' ')
				end
			end
			Result := Result.twin
		end

	name: ZSTRING
		do
			Result := type
		end

feature -- Status change

	set_type_enum_id
		do
			if type.has_substring (Protocol.wireless) then
				if udi_plus_driver_lower (False).has_substring (Protocol.usb) then
					type_enum_id := Network_device_type.USB_IEEE80211
				else
					type_enum_id := Network_device_type.IEEE80211
				end

			elseif type.has_substring (Protocol.bluetooth) then
				type_enum_id := Network_device_type.BLUETOOTH

			elseif type.has_substring (Protocol.ethernet) then
				type_enum_id := Network_device_type.ETHERNET_CSMACD

			else
				type_enum_id := Network_device_type.OTHER
			end
		end

feature -- nmcli fields

	autoconnect: STRING

	connection: STRING

	device: STRING

	driver: STRING

	driver_version: STRING

	firmware_missing: STRING

	firmware_version: STRING

	hwaddr: STRING

	ip_iface: STRING

	nm_managed: STRING

	product: STRING

	reason: STRING

	state: STRING

	type: STRING

	udi: STRING

	vendor: STRING

feature -- Contract Support

	valid_hardware_address (value: STRING): BOOLEAN
		do
			Result := value.occurrences (':') = MAC_address_colon_count
		end

feature {NONE} -- Factory

	new_hardware_address (string: STRING): ARRAY [NATURAL_8]
		local
			byte_list: EL_STRING_8_LIST
		do
			create byte_list.make_with_separator (string, ':', False)
			create Result.make_filled (0, 1, byte_list.count)
			across byte_list as byte loop
				Result [byte.cursor_index] := Hexadecimal.to_integer (byte.item).to_natural_8
			end
		end

feature {NONE} -- Implementation

	udi_plus_driver_lower (keep_ref: BOOLEAN): STRING
		local
			l_buffer: EL_STRING_8_BUFFER_ROUTINES
		do
			Result := l_buffer.copied (udi)
			Result.append (driver)
			Result.to_lower
			if keep_ref then
				Result := Result.twin
			end
		end

feature {NONE} -- Constants

	Default_address: STRING = "00:00:00:00:00:00"

	MAC_address_colon_count: INTEGER = 5

end