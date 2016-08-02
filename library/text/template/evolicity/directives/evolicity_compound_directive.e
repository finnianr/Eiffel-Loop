note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-04-10 14:41:26 GMT (Sunday 10th April 2016)"
	revision: "1"

class
	EVOLICITY_COMPOUND_DIRECTIVE

inherit
	EVOLICITY_DIRECTIVE
		undefine
			copy, is_equal
		end

	ARRAYED_LIST [EVOLICITY_DIRECTIVE]
		rename
			make as make_array
		end

create
	make

feature -- Initialization

	make
			--
		do
			make_array (7)
		end

feature -- Access

	minimum_buffer_length: INTEGER
			-- Suggested minimum buffer length to use for output

feature -- Element change

	set_minimum_buffer_length (a_minimum_buffer_length: like minimum_buffer_length)
			-- Set `minimum_buffer_length' to `a_minimum_buffer_length'.
		do
			minimum_buffer_length := a_minimum_buffer_length
		ensure
			minimum_buffer_length_assigned: minimum_buffer_length = a_minimum_buffer_length
		end

feature -- Basic operations

	execute (context: EVOLICITY_CONTEXT; output: EL_OUTPUT_MEDIUM)
			--
		local
			i: INTEGER
		do
			from i := 1 until i > count loop
				i_th (i).execute (context, output)
				i := i + 1
			end
		end

end -- class EVOLICITY_COMPOUND_DIRECTIVE
