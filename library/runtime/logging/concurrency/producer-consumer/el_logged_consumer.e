note
	description: "Summary description for {EL_LOGGED_CONSUMER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-02 10:22:06 GMT (Saturday 2nd July 2016)"
	revision: "3"

deferred class
	EL_LOGGED_CONSUMER [P]

inherit
	EL_CONSUMER [P]
		redefine
			consume_next_product, product_queue
		end

	EL_MODULE_LOG

feature {NONE} -- Implementation

	consume_next_product
			--
		do
			log.enter ("consume_product")
			product := product_queue.removed_item
			consume_product
			log.exit
		end

feature {NONE} -- Internal attributes

	product_queue: EL_LOGGED_THREAD_PRODUCT_QUEUE [P]

end