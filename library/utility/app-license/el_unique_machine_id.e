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
	date: "2020-08-05 19:45:05 GMT (Wednesday 5th August 2020)"
	revision: "13"

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
			md5.sink_array (mac_address)
		end

feature -- Access

	base_64_value: STRING
		do
			Result := md5.digest_base_64
		end

	array_value: like md5.digest
		do
			Result := md5.digest
		end

	md5: EL_MD5_128
		-- 128 bit MD5 digest

feature {NONE} -- Implementation

	mac_address: ARRAY [NATURAL_8]
		local
			adapter_list: like new_adapter_list
		do
			adapter_list := new_adapter_list
			if adapter_list.is_empty then
				create Result.make_filled (0, 1, 6)
			else
				Result := adapter_list.ordered_by (agent order_key, True).first.address
			end
		end

	new_adapter_list: EL_IP_ADAPTER_LIST_I
		do
			create {EL_IP_ADAPTER_LIST_IMP} Result.make
		end

	order_key (adapter: EL_IP_ADAPTER): INTEGER
		do
			Result := Priority_order.index_of (adapter.type, 1)
		ensure
			not_zero: Result > 0
		end

	log_array (adapter_array: ARRAY [EL_IP_ADAPTER])
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
