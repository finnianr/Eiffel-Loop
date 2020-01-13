note
	description: "Command option list using default option values"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-13 18:27:28 GMT (Monday 13th January 2020)"
	revision: "1"

class
	EL_DEFAULT_COMMAND_OPTION_LIST

inherit
	EL_ARRAYED_LIST [EL_COMMAND_LINE_OPTIONS]
		rename
			make as make_with_size
		end

create
	make

feature {NONE} -- Initialization

	make (options: ARRAY [EL_COMMAND_LINE_OPTIONS])
		do
			make_with_size (options.count)
			across options as opt loop
				extend (opt.item.new_default)
			end
		end

end
