note
	description: "Basic OS release information"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-08 15:28:26 GMT (Friday 8th January 2021)"
	revision: "5"

deferred class
	EL_OS_RELEASE_I

inherit
	EL_ZSTRING_CONSTANTS

	EL_MODULE_BUFFER

feature -- Access

	description: ZSTRING
		do
			Result := Template #$ [name, major_version, minor_version]
		end

	major_version: INTEGER
		deferred
		end

	minor_version: INTEGER
		deferred
		end

	name: ZSTRING
		deferred
		end

feature {NONE} -- Constants

	Template: ZSTRING
		once
			Result := "%S: %S.%S"
		end
end