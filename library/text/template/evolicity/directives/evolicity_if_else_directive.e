note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EVOLICITY_IF_ELSE_DIRECTIVE

inherit
	EVOLICITY_COMPOUND_DIRECTIVE
		redefine
			execute
		end

create
	make

feature -- Element change

	set_boolean_expression (a_boolean_expression: EVOLICITY_BOOLEAN_EXPRESSION)
			--
		do
			boolean_expression := a_boolean_expression
		end

feature -- Basic operations

	set_if_true_interval
			--
		do
			create if_true_interval.make (1, count)
		end

	set_if_false_interval
			--
		do
			if if_true_interval = Void then
				set_if_true_interval
			end
			create if_false_interval.make (
				if_true_interval.upper + 1, count.max (if_true_interval.upper + 1)
			)
		end

	execute (context: EVOLICITY_CONTEXT; output: EL_OUTPUT_MEDIUM)
			--
		do
			boolean_expression.evaluate (context)
			if boolean_expression.is_true then
				from start until index > if_true_interval.upper loop
					item.execute (context, output)
					forth
				end
			else
				from
					go_i_th (if_false_interval.lower)
				until after loop
					item.execute (context, output)
					forth
				end
			end
		end

feature {NONE} -- Implementation

	boolean_expression: EVOLICITY_BOOLEAN_EXPRESSION

	if_true_interval: INTEGER_INTERVAL

	if_false_interval: INTEGER_INTERVAL

end
