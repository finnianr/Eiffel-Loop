note
	description: "Summary description for {EL_HTTP_PARAMETER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
	revision: "2"

deferred class
	EL_HTTP_PARAMETER

feature -- Basic operations

	extend (table: EL_HTTP_HASH_TABLE)
		deferred
		end

end