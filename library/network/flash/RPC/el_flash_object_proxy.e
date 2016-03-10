note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_FLASH_OBJECT_PROXY

inherit
	EL_MODULE_LOG

	ASCII
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	make (a_procedure_call_request_queue: EL_THREAD_PRODUCT_QUEUE [STRING])

			--		<flash-procedure-call>
			--			<object-name>$object_name</object-name>
			--			<procedure-name>$procedure_name</procedure-name>
			--			<arguments>
			--				<Number>$arg1</Number>
			--				<Boolean>$arg2</Boolean>
			--				<String>$arg3</String>
			--				<Array>
			--					<Number>1</Number>
			--					<Number>2</Number>
			--					<Number>3</Number>
			--				</Array>
			--			</arguments>
			--		</flash-procedure-call>

		do
			procedure_call_request_queue := a_procedure_call_request_queue
			create flash_procedure_call_xml.make ("flash-procedure-call")

			create object_name_xml.make ("object-name")
			object_name_xml.set_string_value (object_name)

			create procedure_name_xml.make ("procedure-name")
			create arguments_xml.make ("arguments")
			create number_arg_xml.make ("Number")
			create boolean_arg_xml.make ("Boolean")
			create string_arg_xml.make ("String")
			create array_arg_xml.make ("Array")
			create nested_array_arg_xml.make ("Array")
		end

feature {NONE} -- Basic operations

	put_integer_arg (value: INTEGER)
			--
		require
			call_prepared: is_call_prepared
		do
			number_arg_xml.set_integer_value (value)
			arguments_xml.append_child_tags (number_arg_xml)
		end

	put_real_arg (value: REAL)
			--
		require
			call_prepared: is_call_prepared
		do
			number_arg_xml.set_real_value (value)
			arguments_xml.append_child_tags (number_arg_xml)
		end

	put_boolean_arg (value: BOOLEAN)
			--
		require
			call_prepared: is_call_prepared
		do
			boolean_arg_xml.set_boolean_value (value)
			arguments_xml.append_child_tags (boolean_arg_xml)
		end

	put_string_arg (value: STRING)
			-- Substitute variable with value
		require
			call_prepared: is_call_prepared
		do
			string_arg_xml.set_string_value (value)
			arguments_xml.append_child_tags (string_arg_xml)
		end

	put_numeric_array_arg (numeric_array: ARRAY [NUMERIC])
			--
		require
			call_prepared: is_call_prepared
		local
			i: INTEGER
		do
			array_arg_xml.remove_children
			from
				i := 1
			until
				i > numeric_array.count
			loop
				number_arg_xml.set_string_value (numeric_array.item (i).out)
				array_arg_xml.append_child_tags (number_arg_xml)
				i := i + 1
			end
			arguments_xml.append_child_tags (array_arg_xml)
		end

	put_numeric_rows_and_cols_arg (rows_and_cols_array: ARRAY [ARRAY [NUMERIC]])
			--
		require
			call_prepared: is_call_prepared
		local
			i, j: INTEGER
			numeric_array: ARRAY [NUMERIC]
		do
			array_arg_xml.remove_children
			from
				i := 1
			until
				i > rows_and_cols_array.count
			loop
				numeric_array := rows_and_cols_array [i]
				nested_array_arg_xml.remove_children
				from
					j := 1
				until
					j > numeric_array.count
				loop
					number_arg_xml.set_string_value (numeric_array.item (j).out)
					nested_array_arg_xml.append_child_tags (number_arg_xml)
					j := j + 1
				end
				array_arg_xml.append_child_tags (nested_array_arg_xml)
				i := i + 1
			end
			arguments_xml.append_child_tags (array_arg_xml)
		end

	prepare_call (procedure_name: STRING)
			-- Prepares object for a call to be made to the procedure

			--		<flash-procedure-call>
			--			<object-name>$object_name</object-name>
			--			<procedure-name>$procedure_name</procedure-name>
			--			<arguments>
			--				<Number>$arg1</Number>
			--				<String>$arg1</String>
			--				<Array>
			--					<Number>1</Number>
			--					<Number>2</Number>
			--					<Number>3</Number>
			--				</Array>
			--			</arguments>
			--		</flash-procedure-call>

		do
			flash_procedure_call_xml.remove_children

			procedure_name_xml.set_string_value (procedure_name)
			arguments_xml.remove_children

			is_call_prepared := true
		end

	request_call
			--
		require
			call_prepared: is_call_prepared
		local
			procedure_call_message: STRING
		do
			flash_procedure_call_xml.append_child_tags (object_name_xml)
			flash_procedure_call_xml.append_child_tags (procedure_name_xml)
			flash_procedure_call_xml.append_child_tags (arguments_xml)

			procedure_call_message := flash_procedure_call_xml.to_string
			procedure_call_request_queue.put (procedure_call_message)
			is_call_prepared := false;
		end

feature {NONE} -- Status query

	is_call_prepared: BOOLEAN

feature {NONE} -- Implementation

	procedure_call_request_queue: EL_THREAD_PRODUCT_QUEUE [STRING]

	object_name: STRING
			--
		deferred
		end

	flash_procedure_call_xml: EL_XML_PARENT_TAG_LIST

	object_name_xml: EL_XML_VALUE_TAG_PAIR

	procedure_name_xml: EL_XML_VALUE_TAG_PAIR

	arguments_xml: EL_XML_PARENT_TAG_LIST

	number_arg_xml: EL_XML_VALUE_TAG_PAIR

	boolean_arg_xml: EL_XML_VALUE_TAG_PAIR

	string_arg_xml: EL_XML_VALUE_TAG_PAIR

	array_arg_xml: EL_XML_PARENT_TAG_LIST

	nested_array_arg_xml: EL_XML_PARENT_TAG_LIST

end



