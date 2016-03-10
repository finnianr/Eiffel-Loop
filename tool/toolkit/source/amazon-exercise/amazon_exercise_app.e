note
	description: "[
		Write two functions with corresponding unit tests to reverse the order of a linked list 
		using your implementation.
		
			You must provide:

			1. An iterative solution.
			2. A recursive solution.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:34 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	AMAZON_EXERCISE_APP

inherit
	EL_SUB_APPLICATION
		redefine
			Option_name
		end
create
	make

feature {NONE} -- Initialization

	initialize
			--
		do
			create list
		end

feature -- Basic operations

	run
			--
		local
			i: INTEGER
		do
			log.enter ("run")

			from i := 0 until i > 3 loop
				test_list (1 |..| i, agent list.reverse)
				test_list (1 |..| i, agent list.reverse_recursively)
				i := i + 1
			end
			log.exit
		end


feature {NONE} -- Implementation

	test_list (interval: INTEGER_INTERVAL; reverse_procedure: PROCEDURE [MY_LINKED_LIST [INTEGER], TUPLE])
			--
		local
			i: INTEGER
			failure: BOOLEAN
		do
			log.enter ("test_list")
			log.put_integer_interval_field ("Interval", interval)
			log.put_new_line

			list.wipeout
			interval.do_all (agent list.extend)

			log.put_integer_field ("List count", list.count)
			log.put_new_line

			reverse_procedure.apply

			from i := interval.upper; list.start until failure or i < interval.lower loop
				if list.item /= i then
					failure := True
				end
				i := i - 1; list.forth
			end
			if failure then
				log_or_io.put_line ("List reverse failed")
				print_list
			else
				log_or_io.put_line ("Reversal OK!")
			end
			log.exit
		end

	print_list
			--
		do
			from list.start until list.after loop
				log.put_integer_field ("Item " + list.index.out, list.item)
				log.put_new_line
				list.forth
			end
			log.put_new_line
		end

	list: MY_LINKED_LIST [INTEGER]

feature {NONE} -- Constants

	Option_name: STRING = "amazon"

	Description: STRING = "Exercise for Amazon Data Services Ltd"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{AMAZON_EXERCISE_APP}, "*"]
			>>
		end

end
