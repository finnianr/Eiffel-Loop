note
	description: "Shared instance of ${EL_WEB_ARCHIVE_HTTP_CONNECTION}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-16 8:42:47 GMT (Wednesday 16th October 2024)"
	revision: "1"

deferred class
	EL_MODULE_WEB_ARCHIVE

inherit
	EL_MODULE

feature {NONE} -- Constants

	Web_archive: EL_WEB_ARCHIVE_HTTP_CONNECTION
		once
			create Result.make
		end

end