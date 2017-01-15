note
	description: "Summary description for {EL_UNIQUE_MACHINE_ID}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-11-17 16:32:45 GMT (Thursday 17th November 2016)"
	revision: "3"

class
	EL_UNIQUE_MACHINE_ID

inherit
	KL_PART_COMPARATOR [EL_IP_ADAPTER]
		export
			{NONE} all
		end

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
			md5.sink_string (OS.Cpu_model_name)
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
			sorter: DS_ARRAY_QUICK_SORTER [EL_IP_ADAPTER]
			adapter_array: ARRAY [EL_IP_ADAPTER]
		do
--			log.enter ("mac_address")
			create sorter.make (Current)
			adapter_array := new_adapter_list.to_array

--			log_array (adapter_array)
--			log.put_line ("Sorting")

			sorter.sort (adapter_array)

--			log_array (adapter_array)
--			log.put_string_field ("Name", adapter_array.item (1).name)
--			log.put_new_line
--			log.put_string_field ("MAC", adapter_array.item (1).address_string)
--			log.put_new_line

			if adapter_array.is_empty then
				create Result.make_filled (0, 1, 6)
			else
				Result := adapter_array.item (1).address
			end
--			log.exit
		end

	new_adapter_list: EL_IP_ADAPTER_LIST_I
		do
			create {EL_IP_ADAPTER_LIST_IMP} Result.make
		end

	less_than (u, v: EL_IP_ADAPTER): BOOLEAN
			-- Is `u' considered less than `v'?
		do
			Result := type_order (u.type) < type_order (v.type)
		end

	type_order (type: INTEGER): INTEGER
		local
			order_list: like Selection_order
		do
			order_list := Selection_order
			order_list.start
			order_list.search (type)
			Result := order_list.index
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

	Selection_order: ARRAYED_LIST [INTEGER]
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
