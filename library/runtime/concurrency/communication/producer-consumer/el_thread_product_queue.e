note
	description: "Thread safe queue"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-03-13 12:51:05 GMT (Wednesday 13th March 2013)"
	revision: "2"

class
	EL_THREAD_PRODUCT_QUEUE [P]

inherit
	ARRAYED_QUEUE [P]
		rename
			make as make_queue,
			item as queue_item,
			is_empty as is_queue_empty,
			put as queue_put,
			wipe_out as queue_wipe_out,
			remove as queue_remove
		export
			{NONE} all
		end

	EL_SINGLE_THREAD_ACCESS
		undefine
			is_equal, copy
		end

create
	make

feature -- Initialization

	make
			-- Create linked queue.
		do
			make_thread_access
			make_queue (50)
		end

feature -- Removal

	removed_item: P
			-- Atomic action to ensure removed item belongs to same thread as the item
			-- CQS isn't everything you know.
		do
			restrict_access
			Result := queue_item
			queue_remove

			end_restriction
		end

	logged_removed_item: P
			-- Same as 'removed_item' but logged
		do
			log.enter ("removed_item")
			logged_restrict_access
			Result := queue_item
			queue_remove
			log.put_line (Result.out)

			end_restriction
			log.exit
		end

feature -- Status report

	is_empty: BOOLEAN
			--
		do
			restrict_access
			Result := is_queue_empty

			end_restriction
		end

feature -- Element change

	put (v: P)
			--
		do
			restrict_access
			queue_put (v)
			consumer.prompt

			end_restriction
		end

	logged_put (v: P)
			-- Same as 'put' but logged
		do
			log.enter ("put")
			logged_restrict_access
			log.put_line (v.out)

			queue_put (v)
			consumer.prompt

			end_restriction
			log.exit
		end

	wipe_out
			--
		do
			restrict_access
			queue_wipe_out

			end_restriction
		end

	attach_consumer (a_consumer: like consumer)
			-- Link product queue to it's consumer
		do
			restrict_access
			consumer := a_consumer
			consumer.set_product_queue (Current)

			end_restriction
		end

feature {EL_CONSUMER} -- Element change

	set_consumer (a_consumer: like consumer)
			--
		do
			restrict_access
			consumer := a_consumer

			end_restriction
		end

feature {NONE} -- Implementation

	consumer: EL_CONSUMER [P]

end






