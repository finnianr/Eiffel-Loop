note
	description: "Status of IP address blocked by UFW firewall on a port at a date"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-17 9:58:28 GMT (Thursday 17th October 2024)"
	revision: "1"

class
	RANGE_FIREWALL_STATUS

inherit
	EL_FIREWALL_STATUS
		redefine
			Range_table
		end

create
	default_create, make_from_compact

feature {NONE} -- Constants

	Range_table: EL_ATTRIBUTE_RANGE_TABLE
		once
			create Result
			Result [$compact_date] := compact_date.Min_value |..| compact_date.Max_value
			Result [$http_blocked] := 0 |..| 1
			Result [$smtp_blocked] := 0 |..| 1
			Result [$ssh_blocked] := 0 |..| 1
			Result.initialize (Current)
		end

end