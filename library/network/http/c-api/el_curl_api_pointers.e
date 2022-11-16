note
	description: "API pointers for shared object libcurl"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "4"

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