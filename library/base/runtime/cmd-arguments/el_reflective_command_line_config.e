note
	description: "Reflective command line config"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-30 16:53:19 GMT (Monday 30th December 2019)"
	revision: "1"

deferred class
	EL_REFLECTIVE_COMMAND_LINE_CONFIG

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			export_name as export_default,
			import_name as import_default
		end

feature {NONE} -- Initialization

	make
		do
			make_default
		end
end
