note
	description: "Fast-CGI HTTP servlet"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-24 8:05:00 GMT (Monday 24th February 2025)"
	revision: "26"

deferred class
	FCGI_HTTP_SERVLET

inherit
	ANY

	EL_MODULE_DATE_TIME; EL_MODULE_IP_ADDRESS; EL_MODULE_LOG

	EL_SHARED_HTTP_STATUS; EL_SHARED_DOCUMENT_TYPES

	FCGI_SHARED_HEADER

feature {NONE} -- Initialization

	make (a_service: like service)
		do
			service := a_service
			create response.make (a_service.broker)
			create request.make (Current)
			create last_modified_gmt.make_empty
		end

feature -- Access

	last_modified: INTEGER
		-- Unix time stamp
		do
		end

	servlet_info: STRING
			-- Information about the servlet, such as, author, version and copyright.
		do
			Result := generator
		end

feature -- Basic operations

	log_service_error
			-- Called if service routine generates an exception; may be redefined by descendents
		do
			-- Nothing by default
		end

	log_write_error (the_response: FCGI_SERVLET_RESPONSE)
			-- Called if there was a problem sending response to the client
			-- May be redefined by descendents
		do
			-- Nothing by default
		end

	serve_request
		local
			action: STRING
		do
			log.enter_no_header (once "serve_request")

			response.reset; request.reset

--			Serve request
			serve

			if is_caching_disabled then
				response.set_header (Header.cache_control, once "no-cache, no-store, must-revalidate"); -- HTTP 1.1.
				response.set_header (Header.pragma, once "no-cache"); -- HTTP 1.0.
				response.set_header (Header.expires, once "0"); -- Proxies.

			elseif last_modified.to_boolean then
			-- Last-Modified: Tue, 03 Nov 2024 13:45:00 GMT
				Date_time.format_to (last_modified_gmt, Date_time_format, last_modified, Date_time.Zone.GMT)
				response.set_header (Header.last_modified, last_modified_gmt)
			-- max-age is 24 hours
				response.set_header (Header.cache_control, once "max-age=86400, must-revalidate")
			end
			response.send

			if response.write_ok then
				action := if response.is_head_request then once "HEAD" else once "Sent" end
				log.put_string (action)
				log.put_integer_field (once " content bytes", response.content_length)
				log.put_new_line

				service.broker.set_end_request_listener (request)
			else
				log_write_error (response)
			end
			log.exit_no_trailer
		rescue
			log_service_error
			log.exit_no_trailer
		end

feature -- Status query

	is_caching_disabled: BOOLEAN
		-- stop browser from caching this page
		do
		end

feature {FCGI_SERVLET_REQUEST, FCGI_SERVLET_SERVICE} -- Event handling

	on_serve_done
			-- called on successful write of servlet response. See {FCGI_REQUEST}.end_request
		do
		end

	on_shutdown
		-- called when service is shutting down
		do
		end

feature {NONE} -- Implementation

	new_host_address: NATURAL
		--	inconsistent: does not match ip address of a localhost curl request
		local
			host_info: EL_CAPTURED_OS_COMMAND
		do
			create host_info.make ("hostname -I")
			host_info.execute
			across host_info.lines as line until Result > 0 loop
				Result := Ip_address.to_number (line.item.substring_to (' '))
			end
		end

	serve
		-- set content in `response' for `request'
		deferred
		end

feature {FCGI_SERVLET_REQUEST} -- Internal attributes

	request: FCGI_SERVLET_REQUEST

	response: FCGI_SERVLET_RESPONSE

	service: FCGI_SERVLET_SERVICE

	last_modified_gmt: STRING

feature {NONE} -- Constants

	Date_time_format: STRING = "Ddd, [0]dd Mmm yyyy [0]hh:[0]mi:[0]ss"

end