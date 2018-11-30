note
	description: "Agent experiments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-30 12:27:34 GMT (Friday 30th November 2018)"
	revision: "1"

class
	AGENT_EXPERIMENTS

inherit
	EXPERIMENTAL

feature -- Basic operations

	open_function_target
		local
			duration: FUNCTION [AUDIO_EVENT, REAL]
			event: AUDIO_EVENT
		do
			duration := agent {AUDIO_EVENT}.duration
			lio.put_string ("duration.is_target_closed: ")
			lio.put_boolean (duration.is_target_closed)
			lio.put_new_line
			lio.put_integer_field ("duration.open_count", duration.open_count)
			lio.put_new_line
			create event.make (1, 3)
			duration.set_operands ([event])
			duration.apply
			lio.put_double_field ("duration.last_result", duration.item ([event]))
		end

	polymorphism
		local
			append: PROCEDURE [READABLE_STRING_GENERAL]
			general: STRING_GENERAL
			str_8: STRING_8; str_32: STRING_32
		do
			create str_8.make_empty; create str_32.make_empty
			general := str_8
			append := agent general.append
			append ("abc")
			lio.put_string_field ("str_8", str_8)
			lio.put_new_line
			append.set_target (str_32)
			append ("abc")
			lio.put_string_field ("str_32", str_32)
			lio.put_new_line
		end

	procedure_call
		local
			procedure: PROCEDURE
		do
			procedure := agent log_integer (?, "n")
			procedure (2)
		end

	twinning_procedures
		local
			action, action_2: PROCEDURE [STRING]
		do
			action := agent hello_routine
			action_2 := action.twin
			action_2.set_operands (["wonderful"])
			action_2.apply
		end

feature {NONE} -- Implementation

	log_integer (n: INTEGER; str: STRING)
		do
			lio.put_integer_field (str, n)
			lio.put_new_line
		end
		
	hello_routine (a_arg: STRING)
		do
			lio.enter_with_args ("hello_routine", << a_arg >>)
			lio.exit
		end

end
