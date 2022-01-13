note
	description: "Default do nothing command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-13 12:55:47 GMT (Thursday 13th January 2022)"
	revision: "6"

class
	EL_DEFAULT_COMMAND

inherit
	EL_COMMAND
		rename
			default_description as description
		end

feature -- Basic operations

	execute
		do
		end

end