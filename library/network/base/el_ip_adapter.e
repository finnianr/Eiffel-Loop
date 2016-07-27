note
	description: "Summary description for {EL_IP_ADAPTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-06 12:57:27 GMT (Monday 6th June 2016)"
	revision: "4"

class
	EL_IP_ADAPTER

inherit
	EL_IP_ADAPTER_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_type: like type; a_name, a_description: like name; a_address: like address)
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

	name: ZSTRING

	description: ZSTRING

	type: INTEGER

end