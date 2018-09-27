note
	description: "Logged thread safe stack"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_LOGGED_THREAD_SAFE_STACK [G]

inherit
	EL_THREAD_SAFE_STACK [G]
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

	removed_item: G
			-- Same as 'removed_item' but logged
		do
			log.enter ("removed_item")
			restrict_access
				Result := stack_item
				stack_remove
				log.put_line (Result.out)
			end_restriction
			log.exit
		end

feature -- Element change

	put (v: G)
			-- Same as 'put' but logged
		do
			log.enter ("put")
			restrict_access
				log.put_line (v.out)
				stack_put (v)
			end_restriction
			log.exit
		end
end