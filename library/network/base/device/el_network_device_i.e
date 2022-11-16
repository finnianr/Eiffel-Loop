note
	description: "Network adapter device"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "4"

deferred class
	EL_NETWORK_DEVICE_I

inherit
	EL_SHARED_NETWORK_DEVICE_TYPE

	EL_MODULE_TUPLE

feature -- Access

	address: ARRAY [NATURAL_8]
		deferred
		end

	address_out: STRING
		do
			create Result.make (address.count * 3 - 1)
			across address as byte loop
				if byte.cursor_index > 1 then
					Result.append_character (':')
				end
				Result.append (byte.item.to_hex_string)
			end
		end

	description: ZSTRING
		deferred
		end

	name: ZSTRING
		deferred
		end

	type_enum_id: NATURAL_8

	type_name: STRING
		do
			Result := Network_device_type.name (type_enum_id)
		end

feature -- Status change

	set_type_enum_id
		deferred
		end

feature -- Status query

	has_address: BOOLEAN
		do
			Result := across address as byte some
				byte.item > 0
			end
		end

feature {NONE} -- Constants

	Protocol: TUPLE [bluetooth, ethernet, usb, wireless: STRING]
		once
			create Result
			Tuple.fill (Result, "bluetooth, ethernet, usb, wireless")
		end

end