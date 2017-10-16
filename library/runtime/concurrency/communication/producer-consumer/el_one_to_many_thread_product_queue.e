note
	description: "Product queue serviced by many consumers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_ONE_TO_MANY_THREAD_PRODUCT_QUEUE [P, CONSUMER_TYPE -> EL_MANY_TO_ONE_CONSUMER_THREAD [P] create make end]

inherit
	EL_THREAD_PRODUCT_QUEUE [P]
		rename
			make as make_product_queue,
			consumer as delegator,
			attach_consumer as attach_delegator
		redefine
			delegator
		end

create
	make

feature -- Initialization

	make (consumer_count_max: INTEGER; thread_manager: EL_THREAD_MANAGER)
			--
		do
			make_product_queue
			create available_consumers.make (consumer_count_max)
			create all_consumers.make (consumer_count_max)
			attach_delegator (create {like delegator}.make)
			thread_manager.extend (delegator)
		end

feature -- Basic operations

	launch
			--
		do
			delegator.launch
			across all_consumers as consumer loop
				consumer.item.launch
			end
		end

feature {EL_DELEGATING_CONSUMER_THREAD} -- Access

	available_consumers: EL_THREAD_SAFE_STACK [CONSUMER_TYPE]

	all_consumers: ARRAYED_LIST [CONSUMER_TYPE]

feature {NONE} -- Implementation

	delegator: EL_DELEGATING_CONSUMER_THREAD [P, CONSUMER_TYPE]

end