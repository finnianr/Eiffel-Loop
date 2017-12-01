note
	description: "Summary description for {EL_HTTP_SERVLET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-30 11:42:24 GMT (Thursday 30th November 2017)"
	revision: "5"

deferred class
	FCGI_HTTP_SERVLET

inherit
	EL_MODULE_LOG
		export
			{NONE} all
		end

	EL_HTTP_CONTENT_TYPE_CONSTANTS

feature {NONE} -- Initialization

	make (a_servlet_config: like servlet_config)
		do
			servlet_config := a_servlet_config
		end

feature -- Access

	last_modified: DATE_TIME
		do
			Result := Default_date
		end

	servlet_info: STRING
			-- Information about the servlet, such as, author, version and copyright.
		do
			Result := generator
		end

feature -- Basic operations

	log_write_error (the_response: FCGI_SERVLET_RESPONSE)
			-- Called if there was a problem sending response to the client
			-- May be redefined by descendents
		do
			-- Nothing by default
		end

	log_service_error
			-- Called if service routine generates an exception; may be redefined by descendents
		do
			-- Nothing by default
		end

	serve_fast_cgi (fcgi_request: FCGI_REQUEST)
		local
			request: like new_request; response: like new_response
			message: STRING
		do
			log.enter_no_header (once "serve_fast_cgi")
			response := new_response (fcgi_request); request := new_request (response)
			serve (request, response)
			if is_caching_disabled then
				response.set_header (once "Cache-Control", once "no-cache, no-store, must-revalidate"); -- HTTP 1.1.
				response.set_header (once "Pragma", once "no-cache"); -- HTTP 1.0.
				response.set_header (once "Expires", once "0"); -- Proxies.

			elseif last_modified /= Default_date then
				response.set_header (once "Last-Modified", formatted_date (last_modified))
			end
			response.flush_buffer

			if response.write_ok then
				if response.is_head_request then
					message := once "HEAD content bytes"
				else
					message := once "Sent content bytes"
				end
				log.put_integer_field (message, response.content_length)
				log.put_new_line

				fcgi_request.set_end_request_listener (request)
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

feature {NONE} -- Factory

	new_request (response: like new_response): FCGI_SERVLET_REQUEST
		do
			create Result.make (Current, response)
		end

	new_response (fcgi_request: FCGI_REQUEST): FCGI_SERVLET_RESPONSE
		do
			create Result.make (fcgi_request)
		end

feature {FCGI_SERVLET_REQUEST, FCGI_SERVLET_SERVICE} -- Event handling

	on_serve_done (request: like new_request)
			-- called on successful write of servlet response. See {FCGI_REQUEST}.end_request
		do
		end

	on_shutdown
		-- called when service is shutting down
		do
		end

feature {NONE} -- Implementation

	formatted_date (date_time: DATE_TIME): STRING
		local
			l_result: ZSTRING
		do
			l_result := date_time.formatted_out (once "ddd, [0]dd mmm yyyy [0]hh:[0]mi:[0]ss GMT")
			Result := l_result.as_proper_case
		end

	serve (request: like new_request; response: like new_response)
		deferred
		end

	servlet_config: EL_SERVLET_SERVICE_CONFIG

feature {NONE} -- Constants

	Default_date: DATE_TIME
		once
			create Result.make_from_epoch (0)
			Result := Result.Origin
		end
end
