note
	description: "Summary description for {EL_TEST_SERVLET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_TEST_SERVLET

inherit
	EL_HTTP_SERVLET
		redefine
			on_serve_done
		end

create
	make

feature {NONE} -- Basic operations

	serve (request: like new_request; response: like new_response)
		do
			log.enter ("serve")
			log.put_labeled_string ("IP", request.remote_address)
			log.put_new_line
			response.set_content ("Your IP address is: " + request.remote_address, Content_plain_latin_1)
			log.exit
		end

	on_serve_done (request: like new_request)
		do
			log.enter ("on_serve_done")
			log.put_labeled_string ("request.content", request.content)
			log.put_new_line
			log.exit
		end

end