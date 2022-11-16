note
	description: "A reflected [$source NATURAL_32] representing an IP 4 internet address [$source STRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_IP_ADDRESS_REPRESENTATION

inherit
	EL_CODE_32_REPRESENTATION
		rename
			item as address_string
		redefine
			append_comment, to_string, to_value, valid_string
		end

	EL_MODULE_IP_ADDRESS

	EL_STRING_8_CONSTANTS

create
	make

feature -- Conversion

	to_string (a_value: NATURAL): STRING
		do
			Result := Ip_address.to_string (a_value)
		end

	to_value (str: READABLE_STRING_GENERAL): NATURAL
		do
			Result := Ip_address.to_number (Buffer_8.to_same (str))
		end

feature -- Basic operations

	append_comment (field_definition: STRING)
		-- append comment to meta data `field_definition'
		do
			field_definition.append (once " -- IP 4 address as NATURAL_32")
		end

feature -- Contract Support

	valid_string (general: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := Ip_address.is_valid (Buffer_8.to_same (general))
		end
end