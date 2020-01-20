note
	description: "Command option list using default option values"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-20 9:10:42 GMT (Monday 20th January 2020)"
	revision: "2"

class
	EL_DEFAULT_COMMAND_OPTION_LIST

inherit
	EL_ARRAYED_LIST [EL_COMMAND_LINE_OPTIONS]
		rename
			make as make_with_size
		end

	EL_SHARED_MAKEABLE_FACTORY

create
	make

feature {NONE} -- Initialization

	make (options: ARRAY [EL_COMMAND_LINE_OPTIONS])
		do
			make_with_size (options.count)
			across options as opt loop
				if attached {like item} Makeable_factory.new_item_from_type (opt.item.generating_type) as new then
					extend (new)
				end
			end
		ensure
			filled: count = options.count
		end

end
