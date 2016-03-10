note
	description: "Product queue serviced by many consumers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-03-13 16:35:17 GMT (Wednesday 13th March 2013)"
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
			all_consumers.do_all (
				agent (consumer: CONSUMER_TYPE) do consumer.launch end
			)
		end

feature {EL_DELEGATING_CONSUMER_THREAD} -- Access

	available_consumers: EL_THREAD_SAFE_STACK [CONSUMER_TYPE]

	all_consumers: ARRAYED_LIST [CONSUMER_TYPE]

feature {NONE} -- Implementation

	delegator: EL_DELEGATING_CONSUMER_THREAD [P, CONSUMER_TYPE]

end
