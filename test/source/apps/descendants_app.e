note
	description: "Dummy application to catalog descendants"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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


feature {NONE} -- Constants

	Description: STRING = "Dummy application to catalog descendants"

	Option_name: STRING = "descendants"

end
