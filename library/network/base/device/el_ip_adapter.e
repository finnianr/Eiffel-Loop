note
	description: "IP adapter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-05 19:35:51 GMT (Wednesday 5th August 2020)"
	revision: "9"

class
	EL_IP_ADAPTER

inherit
	ANY

	EL_SHARED_NETWORK_DEVICE_TYPE

create
	make

feature {NONE} -- Initialization

	make (a_type: like type; a_name, a_description: like name; a_address: like address)
		require
			valid_type: Network_device_type.is_valid_value (a_type)
		do
			type := a_type; name := a_name; description := a_description; address := a_address
		end

feature -- Access

	address: ARRAY [NATURAL_8]

	address_string: STRING
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

	name: ZSTRING

	type: NATURAL_8

	type_name: STRING
		do
			Result := Network_device_type.field_name (type)
		end

feature -- Status query

	had_default_address: BOOLEAN
		do
			Result := address.is_equal (Default_address)
		end

feature {NONE} -- Constants

	Default_address: ARRAY [NATURAL_8]
		once
			create Result.make_filled (0, 1, 6)
		end

end
