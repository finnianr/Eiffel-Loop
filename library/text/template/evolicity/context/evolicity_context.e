note
	description: "Evolicity context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-30 17:36:21 GMT (Tuesday 30th October 2018)"
	revision: "5"

deferred class
	EVOLICITY_CONTEXT

feature -- Access

	context_item (variable_name: STRING; function_args: TUPLE): ANY
			--
		do
			Result := object_table [variable_name]
		ensure
			valid_result: attached {ANY} Result as object implies is_valid_type (object)
		end

	referenced_item (variable_ref: EVOLICITY_VARIABLE_REFERENCE): ANY
			--
		do
			variable_ref.start
			Result := deep_item (variable_ref)
		end

feature -- Status query

	has_variable (variable_name: STRING): BOOLEAN
			--
		do
			Result := object_table.has (variable_name)
		end

feature -- Element change

	put_boolean (variable_name: STRING; value: BOOLEAN)
			--
		do
			put_variable (value.to_reference, variable_name)
		end

	put_double (variable_name: STRING; value: DOUBLE)
			--
		do
			put_variable (value.to_reference, variable_name)
		end

	put_integer (variable_name: STRING; value: INTEGER)
			--
		do
			put_variable (value.to_reference, variable_name)
		end

	put_variable (object: ANY; variable_name: STRING)
			-- the order (value, variable_name) is special case due to function_item assign in descendant
		do
			object_table [variable_name] := object
		end

	put_natural (variable_name: STRING; value: NATURAL)
			--
		do
			put_variable (value.to_real_32.to_reference, variable_name)
		end

	put_quoted_string (variable_name: STRING; a_string: READABLE_STRING_GENERAL; count: INTEGER)
		local
			l_string: ZSTRING
		do
			create l_string.make_from_general (a_string)
			put_string (variable_name, l_string.quoted (count))
		end

	put_real (variable_name: STRING; value: REAL)
			--
		do
			object_table [variable_name] := value.to_reference
		end

	put_string (variable_name: STRING; value: READABLE_STRING_GENERAL)
			--
		do
			put_variable (value, variable_name)
		end

	put_variables (name_value_pair_list: ARRAY [TUPLE])
			--
		require
			valid_tuples:
				across name_value_pair_list as tuple all
					tuple.item.count = 2 and then attached {READABLE_STRING_GENERAL} tuple.item.reference_item (1)
				end
		local
			value_ref: ANY; variable_name: STRING; name_value_pair: TUPLE
		do
			across name_value_pair_list as pair loop
				name_value_pair := pair.item
				if attached {READABLE_STRING_GENERAL} name_value_pair.reference_item (1) as general_string then
					variable_name := general_string.to_string_8
					if name_value_pair.is_double_item (2) then
						put_double (variable_name, name_value_pair.real_64_item (2))

					elseif name_value_pair.is_real_item (2) then
						put_real (variable_name, name_value_pair.real_32_item (2))

					elseif name_value_pair.is_integer_item (2) then
						put_integer (variable_name, name_value_pair.integer_32_item (2))

					else
						value_ref := name_value_pair.reference_item (2)
						if attached {READABLE_STRING_GENERAL} value_ref as str_value then
							put_string (variable_name, str_value)
						else
							put_string (variable_name, value_ref.out)
						end
					end
				end
			end
		end

feature -- Basic operations

	prepare
			-- prepare to merge with a parent context template
			-- See class EVOLICITY_EVALUATE_DIRECTIVE
		do
		end

feature {EVOLICITY_CONTEXT} -- Implementation

	 deep_item (variable_ref: EVOLICITY_VARIABLE_REFERENCE): ANY
			-- Recurse steps of variable referece to find deepest item
		require
			valid_variable_ref: not variable_ref.off
		local
			last_step: STRING
		do
			Result := context_item (variable_ref.step, variable_ref.arguments)
			if not variable_ref.is_last_step then
				last_step := variable_ref.last_step
				if variable_ref.before_last and then Sequence_features.has (last_step)
					and then attached {FINITE [ANY]} Result as sequence
				then
					-- is a reference to string/list count or empty status
					if last_step.is_equal (Feature_count) then
						Result := sequence.count.to_integer_64.to_reference

					elseif last_step.is_equal (Feature_is_empty) then
						Result := sequence.is_empty.to_reference

					elseif attached {INTEGER_INTERVAL} sequence as interval then
						if last_step.is_equal (Feature_lower) then
							Result := interval.lower.to_reference

						elseif last_step.is_equal (Feature_upper) then
							Result := interval.upper.to_reference
						end
					end

				elseif attached {EVOLICITY_CONTEXT} Result as context_result then
					variable_ref.forth
					Result := context_result.deep_item (variable_ref)

				end
			end
		end

feature {EVOLICITY_COMPOUND_DIRECTIVE} -- Implementation

	is_valid_type (object: ANY): BOOLEAN
			-- object conforms to one of following types
		do
			if attached {EVOLICITY_CONTEXT} object as ctx or
			else attached {ZSTRING} object as zstring or
			else attached {STRING} object as string or
			else attached {BOOLEAN_REF} object as boolean_ref or

			else attached {REAL_REF} object as real_ref or
			else attached {DOUBLE_REF} object as double_ref or

			else attached {INTEGER_REF} object as integer_ref or
			else attached {INTEGER_64_REF} object as integer_64_ref or

			else attached {NATURAL_32_REF} object as natural_ref or
			else attached {NATURAL_64_REF} object as natural_64_ref or

			else attached {SEQUENCE [EVOLICITY_CONTEXT]} object as ctx_sequence or
			else attached {EVOLICITY_OBJECT_TABLE [EVOLICITY_CONTEXT]} object as table or
			else attached {ITERABLE [ANY]} object as iterable or
			else attached {EL_PATH} object as path then
				Result := true

			elseif attached {HASH_TABLE [ANY, HASHABLE]} object as table then
				table.start
				Result := not table.after
					implies is_valid_type (table.key_for_iteration) and is_valid_type (table.item_for_iteration)
			end
		end

	object_table: HASH_TABLE [ANY, STRING]
		deferred
		end

feature {NONE} -- Constants

	Feature_count: STRING = "count"

	Feature_is_empty: STRING = "is_empty"

	Feature_lower: STRING = "lower"

	Feature_upper: STRING = "upper"

	Sequence_features: ARRAY [STRING]
		once
			Result := << Feature_count, Feature_is_empty, Feature_lower, Feature_upper >>
			Result.compare_objects
		end

end
