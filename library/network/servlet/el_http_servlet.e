note
	description: "Summary description for {EL_HTTP_SERVLET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-29 14:09:12 GMT (Monday 29th September 2014)"
	revision: "5"

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

feature {NONE} -- Initialization

	make (a_servlet_config: like servlet_config)
		do
			servlet_config := a_servlet_config
			servlet_info := ""
		end

feature -- Basic operations

	serve_fast_cgi (fast_cgi_request: EL_FAST_CGI_REQUEST)
		local
			request: like Type_request; response: like Type_response
		do
			create response.make (fast_cgi_request)
			create request.make (fast_cgi_request, response)
			serve (request, response)
			response.flush_buffer
			if response.write_ok then
				fast_cgi_request.set_end_request_action (agent on_serve_done (request))
			else
				log_write_error (response)
			end
		rescue
			log_service_error
		end

feature {NONE} -- Type definitions

	Type_request: EL_HTTP_SERVLET_REQUEST
		require
			never_called: False
		once
		end

	Type_response: EL_HTTP_SERVLET_RESPONSE
		require
			never_called: False
		once
		end

feature {NONE} -- Event handling

	on_serve_done (request: like Type_request)
			-- called on successful write of servlet response. See {EL_FAST_CGI_REQUEST}.end_request
		do
		end

feature {NONE} -- Implementation

	serve (request: like Type_request; response: like Type_response)
		deferred
		end

	servlet_config: EL_SERVLET_CONFIG

end
