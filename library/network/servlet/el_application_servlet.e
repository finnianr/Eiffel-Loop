note
	description: "Summary description for {APPLICATION_SERVLET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-10 18:26:45 GMT (Monday 10th June 2013)"
	revision: "3"

class
	EL_APPLICATION_SERVLET [G -> EL_SERVLET_SESSION create make end]

inherit
	EL_HTTP_SERVLET
		redefine
			do_get, do_head, do_post
		end

create
	make

feature -- operations

	do_get (req: GOA_HTTP_SERVLET_REQUEST; resp: GOA_HTTP_SERVLET_RESPONSE)
			-- Called to allow the servlet to handle a GET request.
		local
			user_session: G
			name: STRING
		do
			name := generating_type.generic_parameter_type (1).name
			if req.session.has_attribute (name) then
				if attached {G} req.session.get_attribute (name) as l_user_session then
					user_session := l_user_session
				end
			else
				create user_session.make
				req.session.set_attribute (name, user_session)
			end
			user_session.service (req, resp)
		end

	do_head (req: GOA_HTTP_SERVLET_REQUEST; resp: GOA_HTTP_SERVLET_RESPONSE)
			-- Called to allow the servlet to handle a HEAD request.
		do
			do_get (req, resp)
		end

	do_post (req: GOA_HTTP_SERVLET_REQUEST; resp: GOA_HTTP_SERVLET_RESPONSE)
			-- Called to allow the servlet to handle a POST request.
		do
			do_get (req, resp)
		end

end
