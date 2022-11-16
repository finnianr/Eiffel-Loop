note
	description: "Abstraction to obtain information on latest application version"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

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