note
	description: "Status of IP address blocked by UFW firewall on a port at a date"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-29 17:34:40 GMT (Sunday 29th October 2023)"
	revision: "4"

class
	EL_FIREWALL_STATUS

inherit
	EL_COMPACTABLE_REFLECTIVE
		rename
			compact_value as compact_status
		end

	EL_SHARED_SERVICE_PORT

create
	default_create, make_by_compact

feature -- Access

	blocked_ports: EL_ARRAYED_LIST [NATURAL_16]
		do
			create Result.make (2)
			if http_blocked then
				Result.append (Service_port.HTTP_all)
			end
			if smtp_blocked then
				Result.append (Service_port.SMTP_all)
			end
			if ssh_blocked then
				Result.extend (Service_port.SSH)
			end
		end

	related_ports (port: NATURAL_16): ARRAY [NATURAL_16]
		do
			if port = Service_port.HTTP then
				Result := Service_port.HTTP_all

			elseif port = Service_port.SMTP then
				Result := Service_port.SMTP_all

			elseif port = Service_port.SSH then

				Result := << port >>
			else
				create Result.make_empty
			end
		end

	compact_date: INTEGER
		-- date of intercept

feature -- Status query

	http_blocked: BOOLEAN

	smtp_blocked: BOOLEAN

	ssh_blocked: BOOLEAN

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

feature -- Element change

	allow (port: NATURAL_16)
		do
			set_port_block (port, False)
		end

	set_block (a_compact_date: INTEGER; port: NATURAL_16)
		do
			compact_date := a_compact_date
			set_port_block (port, True)
		end

	wipe_out
		do
			compact_date := 0
			http_blocked := False
			smtp_blocked := False
			ssh_blocked := False
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

	Field_masks: EL_REFLECTED_FIELD_BIT_MASKS
		once
			create Result.make (Current, "[
				compact_date:
					1 .. 32
				http_blocked:
					33 .. 33
				smtp_blocked:
					34 .. 34
				ssh_blocked:
					35 .. 35
			]")
		end

end