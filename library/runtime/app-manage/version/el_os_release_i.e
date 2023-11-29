note
	description: "Basic OS release information"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-29 9:56:42 GMT (Wednesday 29th November 2023)"
	revision: "9"

deferred class
	EL_OS_RELEASE_I

inherit
	EL_OS_DEPENDENT

	EL_ZSTRING_CONSTANTS

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