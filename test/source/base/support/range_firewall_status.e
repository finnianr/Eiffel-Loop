note
	description: "Status of IP address blocked by UFW firewall on a port at a date"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-19 10:59:18 GMT (Saturday 19th April 2025)"
	revision: "3"

class
	RANGE_FIREWALL_STATUS

inherit
	FIREWALL_STATUS
		redefine
			Range_table
		end

create
	default_create, make_from_compact

feature {NONE} -- Constants

	Range_table: EL_ATTRIBUTE_RANGE_TABLE
		once
			create Result.make (field_list)
			Result.set_32 (field ($compact_date), compact_date.Min_value, compact_date.Max_value)
			Result.set_32 (field ($http_blocked), 0, 1)
			Result.set_32 (field ($smtp_blocked), 0, 1)
			Result.set_32 (field ($ssh_blocked), 0, 1)
			Result.initialize
		end

end