note
	description: "Reflective command line config"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

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