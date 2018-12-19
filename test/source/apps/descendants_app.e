note
	description: "Dummy application to catalog descendants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-15 16:46:36 GMT (Saturday 15th December 2018)"
	revision: "1"

class
	DESCENDANTS_APP

inherit
	EL_SUB_APPLICATION
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Basic operations

	initialize
		do
		end

	run
		do
		end

feature {NONE} -- Descendants

	el_consumer: ARRAY [TYPE [EL_CONSUMER [ANY]]]
		do
			Result := <<
				{EL_DELEGATING_CONSUMER_THREAD [ANY, EL_MANY_TO_ONE_CONSUMER_THREAD [ANY]]},
				{EL_COUNT_CONSUMER},
				{EL_MAIN_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER},
				{EL_PROCEDURE_CALL_CONSUMER_MAIN_THREAD [TUPLE]},
				{EL_PROCEDURE_CALL_CONSUMER_MAIN_THREAD [TUPLE]},
				{EL_PROCEDURE_CALL_CONSUMER_THREAD [TUPLE]},
				{EL_TIMED_PROCEDURE_MAIN_THREAD [ANY, TUPLE]},
				{EL_TUPLE_CONSUMER_MAIN_THREAD [TUPLE]},
				{EL_THREAD_REGULAR_INTERVAL_EVENT_CONSUMER},
				{EL_TIMED_PROCEDURE_THREAD  [ANY, TUPLE]}
			>>
		end

	el_linear: ARRAY [TYPE [EL_LINEAR [ANY]]]
		do
			Result := <<
				{EL_UNIQUE_ARRAYED_LIST [HASHABLE]},
				{EL_CALL_SEQUENCE [TUPLE]}
			>>
		end

	el_thread_product_queue: ARRAY [TYPE [EL_THREAD_PRODUCT_QUEUE [ANY]]]
		do
			Result := <<
				{EL_ONE_TO_MANY_THREAD_PRODUCT_QUEUE [ANY, EL_MANY_TO_ONE_CONSUMER_THREAD [ANY]]},
				{EL_PROCEDURE_CALL_QUEUE [TUPLE]}
			>>
		end

	el_identified_thread: ARRAY [TYPE [EL_IDENTIFIED_THREAD]]
		do
			Result := <<
				{EL_WORK_DISTRIBUTION_THREAD},
				{EL_REGULAR_INTERVAL_EVENT_PRODUCER},
				{EL_TUPLE_CONSUMER_THREAD [TUPLE]},
				{EL_TIMEOUT},
				{EL_WORKER_THREAD}
			>>
		end

	hash_table: ARRAY [TYPE [HASH_TABLE [ANY, HASHABLE]]]
		do
			Result := <<
				{EL_CODE_TABLE [HASHABLE]},
				{EL_GROUP_TABLE [ANY, HASHABLE]},
				{EL_TYPE_TABLE [ANY]},
				{EL_UNIQUE_CODE_TABLE [HASHABLE]}
			>>
		end


feature {NONE} -- Constants

	Description: STRING = "Dummy application to catalog descendants"

	Option_name: STRING = "descendants"

end
