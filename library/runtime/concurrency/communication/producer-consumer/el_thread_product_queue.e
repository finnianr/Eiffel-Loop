﻿note
	description: "Thread safe queue"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-02 10:13:05 GMT (Saturday 2nd July 2016)"
	revision: "4"

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
			make_default
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






