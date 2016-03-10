note
	description: "[
		Servlet that returns OK as a response. Useful for closing down a background servlet by
		first calling {EL_FAST_CGI_SERVLET_SERVICE}.set_end_application and then invoking this servlet using CURL.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_OK_SERVLET

inherit
	EL_HTTP_SERVLET

create
	make

feature {NONE} -- Basic operations

	serve (request: like Type_request; response: like Type_response)
		do
			response.send_ok
		end
end
