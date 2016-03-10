note
	description: "Summary description for {EL_EROS_REQUEST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-03-11 17:46:59 GMT (Wednesday 11th March 2015)"
	revision: "4"

class
	EL_EROS_REQUEST

inherit
	EVOLICITY_SERIALIZEABLE_AS_XML
		rename
			make_empty as make
		redefine
			make_default
		end

	EL_MODULE_LOG

create
	make

feature {NONE} -- Initialization

	make_default
			--
		do
			create argument_list.make_empty
			create expression.make_empty
			serializeable_argument := Default_serializeable_argument
			Precursor
		end

feature -- Access

	expression: STRING
		-- Call expression

feature -- Element change

	set_expression_and_serializeable_argument (
		proxy_object: EL_REMOTE_PROXY; a_routine_name: STRING; argument_tuple: TUPLE
	)
			-- Set call expression for processing instruction 'call' and serializeable_argument
		require
			proxy_class_correctly_named: proxy_object.generator.ends_with (Proxy_class_name_suffix)
		local
			l_template: EL_SUBSTITUTION_TEMPLATE [STRING]
			class_name: STRING
		do
			class_name := proxy_object.generator
			class_name.remove_tail (Proxy_class_name_suffix.count)  -- Removes '_PROXY' characters

			serializeable_argument := Default_serializeable_argument

			if argument_tuple.is_empty then
				l_template := Empty_arguments_expression_template
			else
				l_template := Expression_template
				set_argument_list_and_serializeable_argument (argument_tuple)
				l_template.set_variable ("argument_list", argument_list)
			end
			l_template.set_variable ("class_name", class_name)
			l_template.set_variable ("routine_name", a_routine_name)
			expression := l_template.substituted
		end

feature {NONE} -- Implementation

	set_argument_list_and_serializeable_argument (argument_tuple: TUPLE)
			--
		local
			i: INTEGER
			argument: ANY
			list: STRING
		do
			list := argument_list
			list.wipe_out

			from i := 1 until i > argument_tuple.count loop
				if i > 1 then
					list.append (once ", ")
				end
				if argument_tuple.is_reference_item (i) then
					argument := argument_tuple.reference_item (i)
					if attached {EL_EIFFEL_IDENTIFIER} argument as once_function_identifier then
						list.append (once_function_identifier)

					elseif attached {EVOLICITY_SERIALIZEABLE_AS_XML} argument as serializeable then
						serializeable_argument := serializeable
						list.append_character ('{')
						list.append (serializeable.generator)
						list.append_character ('}')

					elseif attached {STRING} argument as string_literal then
						list.append_character ('%'')
						list.append (string_literal)
						list.append_character ('%'')

					end
				else
					list.append (argument_tuple.item (i).out)
				end
				i := i + 1
			end
		end

	serializeable_argument: EVOLICITY_SERIALIZEABLE_AS_XML

	argument_list: STRING
		-- string argument_list

feature {NONE} -- Evolicity

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["serializeable_argument", agent: EVOLICITY_SERIALIZEABLE_AS_XML do Result := serializeable_argument end],
				["expression", agent: STRING do Result := expression end]
			>>)
		end

	Template: STRING =
		--
	"[
		#evaluate ($serializeable_argument.template_name, $serializeable_argument)
		<?call $expression?>
	]"

feature -- Constants

	Default_serializeable_argument: EL_EROS_DEFAULT_ARGUMENT
			--
		once
			create Result.make
		end

	Expression_template: EL_SUBSTITUTION_TEMPLATE [STRING]
			--
		once
			create Result.make (Call_template + " ($argument_list)")
		end

	Empty_arguments_expression_template: EL_SUBSTITUTION_TEMPLATE [STRING]
			--
		once
			create Result.make (Call_template)
		end

	Call_template: STRING = "{$class_name}.$routine_name"

	Proxy_class_name_suffix: STRING = "_PROXY"

end
