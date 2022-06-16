note
	description: "Reflective command line config"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-16 12:38:08 GMT (Thursday 16th June 2022)"
	revision: "2"

deferred class
	EL_REFLECTIVE_COMMAND_LINE_CONFIG

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			foreign_naming as eiffel_naming
		end

feature {NONE} -- Initialization

	make
		do
			make_default
		end
end