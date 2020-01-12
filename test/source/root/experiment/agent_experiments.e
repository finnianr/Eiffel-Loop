note
	description: "Agent experiments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-12 18:49:33 GMT (Sunday 12th January 2020)"
	revision: "5"

class
	AGENT_EXPERIMENTS

inherit
	EXPERIMENTAL

	EL_MODULE_EIFFEL

	EL_ROUTINE_INFO_FACTORY

feature -- Basic operations

	function_info
		do
			if attached {EL_FUNCTION_INFO} new_routine_info ("filled_array", agent filled_array) as info then
				lio.put_labeled_string ("name", info.name)
				lio.put_new_line
				across info.argument_types as arg loop
					lio.put_labeled_string ("arg "+ arg.cursor_index.out, arg.item.name)
					lio.put_new_line
				end
				lio.put_labeled_string ("result", info.result_type.name)
				lio.put_new_line
			end
		end

	function_result_query
		local
			f: FUNCTION [ANY]; t: TYPE [ANY]
			str: STRING
		do
			f := agent: STRING do create Result.make_empty end
			t := Eiffel.type_of_type ({ISE_RUNTIME}.dynamic_type (f)).generic_parameter_type (2)
			f.apply
			if attached {STRING} f.last_result as s then
				str := s
			end
		end

	numeric_reference_conversion
		local
			integer: INTEGER_32_REF
			integer_64: INTEGER_64
		do
			integer := 32
			integer_64 := as_integer_64 (integer)
		end

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

	routine_tagged_out
		local
			routine: PROCEDURE
		do
			routine := agent log_integer
			lio.put_string_field_to_max_length ("routine", routine.tagged_out, 1000)
			lio.put_new_line
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

	as_integer_64 (ref: NUMERIC): INTEGER_64
		local
			to_integer_64: FUNCTION [NUMERIC, INTEGER_64]
		do
			to_integer_64 := agent {INTEGER_32_REF}.to_integer_64
			Result := to_integer_64 (ref)
		end

	filled_array (n: INTEGER; s: STRING): ARRAY [STRING]
		do
			create Result.make_filled (s, 1, n)
		end

	hello_routine (a_arg: STRING)
		do
			lio.enter_with_args ("hello_routine", [a_arg])
			lio.exit
		end

	log_integer (n: INTEGER; str: STRING)
		do
			lio.put_integer_field (str, n)
			lio.put_new_line
		end

end
