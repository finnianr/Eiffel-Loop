note
	description: "A reflected [$source NATURAL_32] representing an IP 4 internet address [$source STRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-18 11:29:33 GMT (Saturday 18th June 2022)"
	revision: "1"

class
	EL_IP_ADDRESS_REPRESENTATION

inherit
	EL_STRING_REPRESENTATION [NATURAL, STRING]
		rename
			item as address_string
		end

	EL_MODULE_IP_ADDRESS

	EL_STRING_8_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
		do
			address_string := Empty_string_8
		end

feature -- Access

	to_string (a_value: NATURAL): STRING
		do
			Result := Ip_address.to_string (a_value)
		end

feature -- Basic operations

	append_comment (field_definition: STRING)
		-- append comment to meta data `field_definition'
		do
			field_definition.append (once " -- IP 4 address as NATURAL_32")
		end

	to_value (str: READABLE_STRING_GENERAL): NATURAL
		do
			Result := Ip_address.to_number (Buffer_8.to_same (str))
		end

end