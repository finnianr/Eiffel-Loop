note
	description: "Fcgi http servlet"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "19"

deferred class
	FCGI_HTTP_SERVLET

inherit
	ANY

	EL_MODULE_LOG

	EL_SHARED_HTTP_STATUS

	EL_SHARED_DOCUMENT_TYPES

	FCGI_SHARED_HEADER

feature {NONE} -- Initialization

	make (a_service: like service)
		do
			service := a_service
			create response.make (a_service.broker)
			create request.make (Current)
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
			message: STRING
		do
			log.enter_no_header (once "serve_request")

			response.reset; request.reset

--			Serve request
			serve

			if is_caching_disabled then
				response.set_header (Header.cache_control, once "no-cache, no-store, must-revalidate"); -- HTTP 1.1.
				response.set_header (Header.pragma, once "no-cache"); -- HTTP 1.0.
				response.set_header (Header.expires, once "0"); -- Proxies.

			elseif last_modified /= Default_date then
				response.set_header (Header.last_modified, formatted_date (last_modified))
			end
			response.send

			if response.write_ok then
				if response.is_head_request then
					message := once "HEAD content bytes"
				else
					message := once "Sent content bytes"
				end
				log.put_integer_field (message, response.content_length)
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

	formatted_date (date_time: DATE_TIME): STRING
		local
			l_result: ZSTRING
		do
			l_result := date_time.formatted_out (once "ddd, [0]dd mmm yyyy [0]hh:[0]mi:[0]ss GMT")
			Result := l_result.as_proper_case
		end

	serve
		-- set content in `response' for `request'
		deferred
		end

feature {FCGI_SERVLET_REQUEST} -- Internal attributes

	request: FCGI_SERVLET_REQUEST

	response: FCGI_SERVLET_RESPONSE

	service: FCGI_SERVLET_SERVICE

feature {NONE} -- Constants

	Default_date: DATE_TIME
		once
			create Result.make_from_epoch (0)
			Result := Result.Origin
		end
end