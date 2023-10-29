note
	description: "Map IP address to status: [$ource EL_FIREWALL_STATUS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-29 17:03:08 GMT (Sunday 29th October 2023)"
	revision: "1"

class
	EL_ADDRESS_FIREWALL_STATUS

inherit
	EL_REFLECTIVELY_SETTABLE_STORABLE
		rename
			foreign_naming as eiffel_naming,
			read_version as read_default_version
		end

	EL_SETTABLE_FROM_STRING_8

create
	make, make_default

feature {NONE} -- Initialization

	make (a_compact_status: NATURAL_64; a_ip4_number: NATURAL)
		do
			compact_status := a_compact_status; ip4_number := a_ip4_number
		end

feature -- Access

	compact_status: NATURAL_64
		-- status that can be expande

	ip4_number: NATURAL
		-- address number

	status: EL_FIREWALL_STATUS
		do
			create Result.make_by_compact (compact_status)
		end

feature {NONE} -- Constants

	Field_hash: NATURAL_32 = 2064550038
end