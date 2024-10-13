note
	description: "Status of IP address blocked by UFW firewall on a port at a date"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-13 8:33:58 GMT (Sunday 13th October 2024)"
	revision: "8"

class
	EL_FIREWALL_STATUS

inherit
	EL_COMPACTABLE_REFLECTIVE
		rename
			compact_natural_64 as compact_status,
			make_from_natural_64 as make_from_compact,
			set_from_natural_64 as set_from_compact
		end

	EL_SHARED_SERVICE_PORT

create
	default_create, make_from_compact

feature -- Access

	blocked_ports: EL_ARRAYED_LIST [NATURAL_16]
		-- list of blocked ports
		do
			create Result.make (3)
			if http_blocked then
				Result.extend (Service_port.HTTP)
			end
			if smtp_blocked then
				Result.extend (Service_port.SMTP)
			end
			if ssh_blocked then
				Result.extend (Service_port.SSH)
			end
		end

feature -- Measurement

	compact_date: INTEGER
		-- date of intercept

	count: INTEGER
		-- count of blocked ports
		do
			Result := http_blocked.to_integer + smtp_blocked.to_integer + ssh_blocked.to_integer
		end

feature -- Status query

	http_blocked: BOOLEAN

	is_blocked (port: NATURAL_16): BOOLEAN
		do
			if port = Service_port.HTTP then
				Result := http_blocked

			elseif port = Service_port.SMTP then
				Result := smtp_blocked

			elseif port = Service_port.SSH then
				Result := ssh_blocked
			end
		end

	smtp_blocked: BOOLEAN

	ssh_blocked: BOOLEAN

feature -- Element change

	allow (port: NATURAL_16)
		do
			set_port_block (port, False)
		end

	block (port: NATURAL_16)
		do
			set_port_block (port, True)
		end

	reset
		do
			set_from_compact (0)
		end

	set_date (a_compact_date: INTEGER)
		do
			compact_date := a_compact_date
		end

feature {NONE} -- Implementation

	set_port_block (port: NATURAL_16; status: BOOLEAN)
		do
			if port = Service_port.HTTP then
				http_blocked := status

			elseif port = Service_port.SMTP then
				smtp_blocked := status

			elseif port = Service_port.SSH then
				ssh_blocked := status
			end
		end

feature {NONE} -- Constants

	Range_table: EL_ATTRIBUTE_BIT_RANGE_TABLE
		once
			create Result.make (Current, "[
				compact_date := 1 .. 32
				http_blocked := 33
				smtp_blocked := 34
				ssh_blocked := 35
			]")
		end

end