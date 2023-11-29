note
	description: "Abstraction to obtain information on latest application version"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-29 9:56:22 GMT (Wednesday 29th November 2023)"
	revision: "3"

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