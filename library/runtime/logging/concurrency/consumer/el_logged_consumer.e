note
	description: "Logged consumer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "6"

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