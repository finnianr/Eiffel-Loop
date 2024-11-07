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
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-06 10:28:52 GMT (Wednesday 6th November 2024)"
	revision: "15"

class
	EL_NETWORK_DEVICE_IMP

inherit
	EL_NETWORK_DEVICE_I

	EL_REFLECTIVELY_SETTABLE
		rename
			make_default as make,
			field_included as is_any_field,
			foreign_naming as Kebab_case_upper
		end

	EL_SETTABLE_FROM_STRING_8
		rename
			make_default as make
		end

	EL_SHARED_ZSTRING_BUFFER_POOL

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
			if attached String_pool.borrowed_item as borrowed then
				if attached borrowed.empty as str then
					across << vendor, product, type >> as list loop
						if not valid_hardware_address (list.item) then
							str.append_string_general (list.item); Result.prune_all_trailing ('-')
						end
						if not str.is_empty and not list.is_last then
							str.append_character (' ')
						end
					end
					Result := str.twin
				end
				borrowed.return
			end
		end

	name: ZSTRING
		do
			Result := type
		end

feature -- Status change

	set_type_enum_id
		do
			if type.has_substring (Protocol.wireless) then
				if udi_plus_driver_lower.has_substring (Protocol.usb) then
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
			byte_list: EL_STRING_8_LIST; hex: EL_HEXADECIMAL_CONVERTER
		do
			create byte_list.make_split (string, ':')
			create Result.make_filled (0, 1, byte_list.count)
			across byte_list as byte loop
				Result [byte.cursor_index] := hex.to_integer (byte.item).to_natural_8
			end
		end

feature {NONE} -- Implementation

	udi_plus_driver_lower: STRING
		do
			Result := udi + driver
			Result.to_lower
		end

feature {NONE} -- Constants

	Default_address: STRING = "00:00:00:00:00:00"

	Kebab_case_upper: EL_KEBAB_CASE_TRANSLATER
		once
			Result := {EL_CASE}.Upper
		end

	MAC_address_colon_count: INTEGER = 5

end