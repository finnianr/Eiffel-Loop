note
	description: "Abstraction to obtain information on latest application version"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-23 10:28:20 GMT (Saturday 23rd October 2021)"
	revision: "1"

deferred class
	EL_SOFTWARE_UPDATE_INFO

inherit
	EL_MAKEABLE

feature -- Access

	latest_version: NATURAL
		deferred
		end

feature -- Basic operations

	build
		deferred
		end

feature -- Status query

	is_valid: BOOLEAN
		deferred
		end
end