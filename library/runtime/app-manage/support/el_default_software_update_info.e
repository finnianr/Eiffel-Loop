note
	description: "Default implementation of [$source EL_SOFTWARE_UPDATE_INFO]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-23 16:04:20 GMT (Saturday 23rd October 2021)"
	revision: "1"

class
	EL_DEFAULT_SOFTWARE_UPDATE_INFO

inherit
	EL_SOFTWARE_UPDATE_INFO
		rename
			build as do_nothing
		end

	EL_MODULE_BUILD_INFO

create
	make

feature {NONE} -- Initialization

	make
		do

		end

feature -- Access

	latest_version: NATURAL
		do
			Result := Build_info.version_number
		end

feature -- Status query

	is_valid: BOOLEAN
		do
			Result := True
		end
end