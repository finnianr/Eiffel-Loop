note
	description: "Summary description for {EL_MODULE_CURL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-03-29 10:12:14 GMT (Sunday 29th March 2015)"
	revision: "5"

class
	EL_MODULE_CURL

inherit
	EL_MODULE

feature {NONE} -- Implementation

	Curl: EL_CURL_ROUTINES
		once ("PROCESS")
			create Result
		end
end
