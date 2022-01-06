note
	description: "Unique machine id based on MAC address of network adapter"
	notes: "[
		Relies on network manager info tool `nmcli' in Linux
		
		The adapter is chosen based on the `Priority_order' constant.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-05 11:55:40 GMT (Wednesday 5th January 2022)"
	revision: "15"

class
	EL_UNIQUE_MACHINE_ID

inherit
	ANY

	EL_MODULE_ENVIRONMENT

	EL_MODULE_OS

	EL_SHARED_NETWORK_DEVICE_TYPE

create
	make

feature {NONE} -- Initialization

	make
		do
			create md5.make
			md5.sink_string_8 (OS.CPU_model_name)
			-- did not realise until 2022 that bytes are in reverse
			md5.sink_array_reversed (mac_address)
		end

feature -- Access

	array_value: like md5.digest
		do
			Result := md5.digest
		end

	base_64_value: STRING
		do
			Result := md5.digest_base_64
		end

	md5: EL_MD5_128
		-- 128 bit MD5 digest

feature {NONE} -- Implementation

	log_array (adapter_array: ARRAY [EL_NETWORK_DEVICE_I])
		do
--			log.enter ("log_array")
			across adapter_array as adapter loop
--				log.put_string_field ("Name", adapter.item.name)
--				log.put_new_line
--				log.put_string_field ("Description", adapter.item.description)
--				log.put_new_line
--				log.put_integer_field ("Type", adapter.item.type)
--				log.put_new_line
--				log.put_string_field ("MAC", adapter.item.address_string)
--				log.put_new_line
--				log.put_new_line
			end
--			log.exit
		end

	mac_address: ARRAY [NATURAL_8]
		local
			adapter_list: like new_adapter_list
		do
			adapter_list := new_adapter_list
			if attached adapter_list.query_if (agent {EL_NETWORK_DEVICE_I}.has_address) as list then
				if list.is_empty then
					create Result.make_filled (0, 1, 6)
				else
					Result := list.ordered_by (agent order_key, True).first.address
				end
			end
		end

	new_adapter_list: EL_NETWORK_DEVICE_LIST_I
		do
			create {EL_NETWORK_DEVICE_LIST_IMP} Result.make
		end

	order_key (adapter: EL_NETWORK_DEVICE_I): INTEGER
		do
			Result := Priority_order.index_of (adapter.type_enum_id, 1)
		ensure
			not_zero: Result > 0
		end

feature {NONE} -- Constants

	Priority_order: EL_ARRAYED_LIST [NATURAL_8]
		once
			create Result.make_from_array (<<
				Network_device_type.ETHERNET_CSMACD,
				Network_device_type.IEEE80211, -- prioritize built-in wireless over plugin USB wireless (next)
				Network_device_type.USB_IEEE80211,
				Network_device_type.BLUETOOTH,
				Network_device_type.ISO88025_TOKENRING,
				Network_device_type.IEEE1394,
				Network_device_type.PPP,
				Network_device_type.ATM,
				Network_device_type.TUNNEL,
				Network_device_type.OTHER,
				Network_device_type.SOFTWARE_LOOPBACK
			>>)
		end

end