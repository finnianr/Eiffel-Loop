note
	description: "Unique machine id"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-27 21:12:25 GMT (Friday 27th December 2019)"
	revision: "9"

class
	EL_UNIQUE_MACHINE_ID

inherit
	EL_IP_ADAPTER_CONSTANTS
		export
			{NONE} all
		end

	EL_MODULE_ENVIRONMENT

	EL_MODULE_OS

create
	make

feature {NONE} -- Initialization

	make
		do
			create md5.make
			md5.sink_string_8 (OS.Cpu_model_name)
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
			ordered_list: LIST [EL_IP_ADAPTER]
		do
			ordered_list := new_adapter_list.ordered_by (agent order_key, True)
			if ordered_list.is_empty then
				create Result.make_filled (0, 1, 6)
			else
				Result := ordered_list.first.address
			end
		end

	new_adapter_list: EL_IP_ADAPTER_LIST_I
		do
			create {EL_IP_ADAPTER_LIST_IMP} Result.make
		end

	order_key (adapter: EL_IP_ADAPTER): INTEGER
		do
			Result := Selection_order.index_of (adapter.type, 1)
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

	Selection_order: EL_ARRAYED_LIST [INTEGER]
		once
			create Result.make_from_array (<<
				Type_ETHERNET_CSMACD,
				Type_IEEE80211,
				Type_BLUETOOTH,
				Type_ISO88025_TOKENRING,
				Type_IEEE1394,
				Type_PPP,
				Type_ATM,
				Type_TUNNEL,
				Type_OTHER,
				Type_SOFTWARE_LOOPBACK
			>>)
		end

end
