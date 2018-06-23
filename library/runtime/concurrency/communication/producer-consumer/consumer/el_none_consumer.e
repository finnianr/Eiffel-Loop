note
	description: "Do nothing consumer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-21 0:00:35 GMT (Thursday 21st June 2018)"
	revision: "1"

class
	EL_NONE_CONSUMER [P]

inherit
	EL_CONSUMER [P]
		rename
			set_product_queue as make
		end

create
	make

feature -- Basic operations

	launch
			-- do another action
		do
		end

	prompt
			-- do another action
		do
		end

	execute
			-- Continuous loop to do action that waits to be prompted
		do
		end

	consume_product
			--
		do
		end

end
