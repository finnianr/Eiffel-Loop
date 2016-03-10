note
	description: "Summary description for {EL_THREAD_SAFE_STACK}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_THREAD_SAFE_STACK [G]

inherit
	ARRAYED_STACK [G]
		rename
			item as stack_item,
			is_empty as is_stack_empty,
			put as stack_put,
			wipe_out as stack_wipe_out,
			remove as stack_remove,
			count as stack_count
		export
			{NONE} all
		redefine
			make
		end

	EL_SINGLE_THREAD_ACCESS
		undefine
			is_equal, copy
		end

create
	make

feature -- Initialization

	make (n: INTEGER)
			-- Create linked stack.
		do
			Precursor (n)
			make_thread_access
		end

feature -- Removal

	removed_item: G
			-- Atomic action to ensure removed item belongs to same thread as the item
			-- CQS isn't everything you know.
		do
			restrict_access
			Result := stack_item
			stack_remove

			end_restriction
		end

	logged_removed_item: G
			-- Same as 'removed_item' but logged
		do
			log.enter ("removed_item")
			logged_restrict_access
			Result := stack_item
			stack_remove
			log.put_line (Result.out)

			end_restriction
			log.exit
		end

feature -- Access

	count: INTEGER
			--
		do
			restrict_access
			Result := stack_count
			end_restriction
		end

feature -- Status report

	is_empty: BOOLEAN
			--
		do
			restrict_access
			Result := is_stack_empty

			end_restriction
		end

feature -- Element change

	put (v: G)
			--
		do
			restrict_access
			stack_put (v)

			end_restriction
		end

	logged_put (v: G)
			-- Same as 'put' but logged
		do
			log.enter ("put")
			logged_restrict_access
			log.put_line (v.out)

			stack_put (v)

			end_restriction
			log.exit
		end

	wipe_out
			--
		do
			restrict_access
			stack_wipe_out

			end_restriction
		end

end
