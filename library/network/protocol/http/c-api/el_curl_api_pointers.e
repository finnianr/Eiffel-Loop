note
	description: "Summary description for {EL_CURL_API_POINTERS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_CURL_API_POINTERS

inherit
	EL_DYNAMIC_MODULE_POINTERS

create
	make

feature {EL_DYNAMIC_MODULE} -- Access

	cleanup: POINTER

	init: POINTER

	perform: POINTER

	getinfo: POINTER

	setopt: POINTER

end
