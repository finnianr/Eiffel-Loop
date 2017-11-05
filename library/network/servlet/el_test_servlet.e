note
	description: "Summary description for {EL_TEST_SERVLET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-30 12:45:11 GMT (Monday 30th October 2017)"
	revision: "3"

class
	EL_TEST_SERVLET

inherit
	FCGI_HTTP_SERVLET
		redefine
			on_serve_done
		end

create
	make

feature {NONE} -- Basic operations

	serve (request: like new_request; response: like new_response)
		do
			log.enter ("serve")
			log.put_labeled_string ("IP", request.headers.remote_addr)
			log.put_new_line
			response.set_content ("Your IP address is: " + request.headers.remote_addr, Content_plain_latin_1)
			log.exit
		end

	on_serve_done (request: like new_request)
		do
			log.enter ("on_serve_done")
			across request.headers.http_parameters as parameter loop
				log.put_labeled_string (parameter.key, parameter.item)
				log.put_new_line
			end
			log.exit
		end

end
