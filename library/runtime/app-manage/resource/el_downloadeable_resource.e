note
	description: "Downloadable resource"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-09 1:09:44 GMT (Wednesday 9th January 2019)"
	revision: "2"

deferred class
	EL_DOWNLOADEABLE_RESOURCE

feature -- Access

	total_bytes: INTEGER
		deferred
		end

feature -- Basic operations

	download
		deferred
		end
end
