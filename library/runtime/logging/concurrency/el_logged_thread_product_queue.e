note
	description: "Logged thread product queue"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_LOGGED_THREAD_PRODUCT_QUEUE [P]

inherit
	EL_THREAD_PRODUCT_QUEUE [P]
		undefine
			restrict_access
		redefine
			removed_item, put
		end

	EL_LOGGED_SINGLE_THREAD_ACCESS
		undefine
			is_equal, copy
		end

create
	make

feature -- Removal

	removed_item: P
			-- Same as 'removed_item' but logged
		do
			log.enter ("removed_item")
			restrict_access
			Result := queue_item
			queue_remove
			log.put_line (Result.out)

			end_restriction
			log.exit
		end

feature -- Element change

	put (v: P)
			-- Same as 'put' but logged
		do
			log.enter ("put")
			restrict_access
			log.put_line (v.out)

			queue_put (v)
			consumer.prompt

			end_restriction
			log.exit
		end

end