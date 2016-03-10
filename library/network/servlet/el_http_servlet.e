note
	description: "Summary description for {EL_HTTP_SERVLET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-30 11:44:56 GMT (Saturday 30th January 2016)"
	revision: "7"

deferred class
	EL_HTTP_SERVLET

inherit
	GOA_HTTP_SERVLET
		export
			{ANY} generator
		redefine
			servlet_config
		end

	EL_MODULE_LOG
		export
			{NONE} all
		end

	EL_HTTP_CONTENT_TYPE_CONSTANTS

feature {NONE} -- Initialization

	make (a_servlet_config: like servlet_config)
		do
			servlet_config := a_servlet_config
			servlet_info := ""
		end

feature -- Access

	last_modified: DATE_TIME
		do
			Result := Default_date
		end

feature -- Basic operations

	serve_fast_cgi (fast_cgi_request: EL_FAST_CGI_REQUEST)
		local
			request: like new_request; response: like new_response
			message: STRING
		do
			log.enter_no_header (once "serve_fast_cgi")
			response := new_response (fast_cgi_request); request := new_request (fast_cgi_request, response)
			serve (request, response)
			if last_modified /= Default_date then
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

				fast_cgi_request.set_end_request_action (agent on_serve_done (request))
			else
				log_write_error (response)
			end
			log.exit_no_trailer
		rescue
			log_service_error
			log.exit_no_trailer
		end

feature {NONE} -- Factory

	new_request (fast_cgi_request: EL_FAST_CGI_REQUEST; response: like new_response): EL_HTTP_SERVLET_REQUEST
		do
			create Result.make (fast_cgi_request, response)
		end

	new_response (fast_cgi_request: EL_FAST_CGI_REQUEST): EL_HTTP_SERVLET_RESPONSE
		do
			create Result.make (fast_cgi_request)
		end

feature {NONE} -- Event handling

	on_serve_done (request: like new_request)
			-- called on successful write of servlet response. See {EL_FAST_CGI_REQUEST}.end_request
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

	servlet_config: EL_SERVLET_CONFIG

feature {NONE} -- Constants

	Default_date: DATE_TIME
		once
			create Result.make_from_epoch (0)
			Result := Result.Origin
		end
end
