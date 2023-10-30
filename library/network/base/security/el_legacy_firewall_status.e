note
	description: "Status of IP address blocked by UFW firewall on a port at a date"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-30 10:23:20 GMT (Monday 30th October 2023)"
	revision: "5"

class
	EL_LEGACY_FIREWALL_STATUS

inherit
	EL_COMPACTABLE_REFLECTIVE
		rename
			compact_value as compact_status
		end

	EL_SHARED_SERVICE_PORT

create
	default_create, make_by_compact

feature -- Access

	compact_date: INTEGER
		-- date of intercept

	port: NATURAL_16
		-- port number

	ports: ARRAY [NATURAL_16]
		-- associated ports
		do
			Result := Service_port.related (port)
		end

feature -- Status query

	is_blocked: BOOLEAN

feature -- Element change

	set (a_compact_date: INTEGER; a_port: NATURAL_16; a_is_blocked: BOOLEAN)
		do
			compact_date := a_compact_date; port := a_port; is_blocked := a_is_blocked
		end

	set_blocked (flag: BOOLEAN)
		do
			is_blocked := flag
		end

	set_port (a_port: like port)
		do
			port := a_port
		end

feature {NONE} -- Constants

	Field_masks: EL_REFLECTED_FIELD_BIT_MASKS
		once
			create Result.make (Current, "[
				compact_date:
					1 .. 32
				port:
					33 .. 48
				is_blocked:
					49 .. 49
			]")
		end

end