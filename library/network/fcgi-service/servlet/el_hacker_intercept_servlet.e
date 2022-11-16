note
	description: "[
		Intercept hacking attempts, returning 404 file not found message as plaintext
		and creating firewall rule blocking IP address
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "13"

class
	EL_HACKER_INTERCEPT_SERVLET

inherit
	FCGI_HTTP_SERVLET
		redefine
			service
		end

	EL_MODULE_TUPLE

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_IP_ADDRESS

	EL_SHARED_IP_ADDRESS_GEOLOCATION

create
	make

feature {NONE} -- Basic operations

	serve
		local
			ip_number: NATURAL; location_status: like new_location_status
		do
			log.enter_no_header ("serve")
			if request.remote_address_32 = Local_host_address then
				ip_number := Test_ip_number
			else
				ip_number := request.remote_address_32
			end
			Location_status_table.set_new_item_target (Current)
			location_status := Location_status_table.item (ip_number)
			log.put_labeled_string (IP_address.to_string (ip_number), location_status.location)
			if location_status.is_blocked then
				log.put_line (" (blocked)")
				location_status.is_blocked := False -- Try again to set firewall rule
			elseif is_hacker_probe (request.relative_path_info.as_lower) then
				log.put_line (" (blocking)")
				service.config.block (IP_address.to_string (ip_number))
				Execution_environment.sleep (500) -- Wait half a second for firewall rule to apply
				location_status.is_blocked := True
			else
				log.put_new_line
			end
			response.send_error (Http_status.not_found, once "File not found", Doc_type_plain_latin_1)
			log.exit_no_trailer
		end

feature {NONE} -- Implementation

	digit_count (path_lower: ZSTRING): INTEGER
		local
			i: INTEGER
		do
			from i := 1 until i > path_lower.count loop
				if path_lower.is_numeric_item (i) then
					Result := Result + 1
				end
				i := i + 1
			end
		end

	is_hacker_probe (path_lower: ZSTRING): BOOLEAN
		do
			if digit_count (path_lower) > Maximum_digits and then not path_lower.ends_with (Dot_png) then
				-- Block requests like: "GET /87543bde9176626b120898f9141058 HTTP/1.1"
				-- but allow: "GET /images/favicon/196x196.png HTTP/1.1"
				Result := True
			else
				Result := service.config.is_hacker_probe (path_lower)
			end
		end

	new_location_status (ip: NATURAL): like Location_status_table.item
		do
			Result := [IP_location_table.item (ip), False]
		end

feature {NONE} -- Implementation: attributes

	service: EL_HACKER_INTERCEPT_SERVICE

feature {NONE} -- Constants

	Dot_png: ZSTRING
		once
			Result := ".png"
		end

	Location_status_table: EL_CACHE_TABLE [TUPLE [location: ZSTRING; is_blocked: BOOLEAN], NATURAL]
		once
			create Result.make (70, agent new_location_status)
		end

	Local_host_address: NATURAL = 0x7F_00_00_01

	Maximum_digits: INTEGER = 3
		-- maximum number of digits allowed in path

feature {NONE} -- String constants

	Test_ip_number: NATURAL
		-- Poland, Łódź Voivodeship"
		once
			Result := IP_address.to_number ("91.196.50.33")
		end

end