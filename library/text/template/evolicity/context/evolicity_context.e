note
	description: "Evolicity context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-09-04 14:24:53 GMT (Sunday 4th September 2022)"
	revision: "10"

deferred class
	EVOLICITY_CONTEXT

inherit
	EL_ZSTRING_ROUTINES
		export
			{NONE} all
		end

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
			put_variable (value.to_reference, variable_name)
		end

	put_quoted_string (variable_name: STRING; a_string: READABLE_STRING_GENERAL; count: INTEGER)
		do
			put_string (variable_name, new_zstring (a_string).quoted (count))
		end

	put_real (variable_name: STRING; value: REAL)
			--
		do
			put_variable (value.to_reference, variable_name)
		end

	put_string (variable_name: STRING; value: READABLE_STRING_GENERAL)
			--
		do
			put_variable (new_zstring (value), variable_name)
		end

	put_variables (name_value_pair_list: ARRAY [TUPLE])
			--
		require
			valid_tuples:
				across name_value_pair_list as tuple all
					tuple.item.count = 2 and then attached {READABLE_STRING_GENERAL} tuple.item.reference_item (1)
				end
		local
			variable_name: STRING; ref_item: ANY
		do
			across name_value_pair_list as pair loop
				if attached {READABLE_STRING_GENERAL} pair.item.reference_item (1) as general_string then
					variable_name := general_string.to_string_8
				end
				inspect pair.item.item_code (2)
					when {TUPLE}.Character_8_code then
						put_variable (pair.item.character_8_item (2).out, variable_name)

					when {TUPLE}.Character_32_code then
						put_variable (pair.item.character_32_item (2).out, variable_name)

					when {TUPLE}.Boolean_code then
						put_boolean (variable_name, pair.item.boolean_item (2))

					when {TUPLE}.Integer_8_code then
						put_integer (variable_name, pair.item.integer_8_item (2))

					when {TUPLE}.Integer_16_code then
						put_integer (variable_name, pair.item.integer_16_item (2))

					when {TUPLE}.Integer_32_code then
						put_integer (variable_name, pair.item.integer_32_item (2))

					when {TUPLE}.Integer_64_code then
						put_variable (pair.item.integer_64_item (2).to_reference, variable_name)

					when {TUPLE}.Natural_8_code then
						put_natural (variable_name, pair.item.natural_8_item (2))

					when {TUPLE}.Natural_16_code then
						put_natural (variable_name, pair.item.natural_16_item (2))

					when {TUPLE}.Natural_32_code then
						put_natural (variable_name, pair.item.natural_32_item (2))

					when {TUPLE}.Natural_64_code then
						put_variable (pair.item.natural_64_item (2).to_reference, variable_name)

					when {TUPLE}.Real_32_code then
						put_real (variable_name, pair.item.real_32_item (2))

					when {TUPLE}.Real_64_code then
						put_double (variable_name, pair.item.real_64_item (2))

					when {TUPLE}.Reference_code then
						ref_item := pair.item.reference_item (2)
						if attached {READABLE_STRING_GENERAL} ref_item as general then
							 put_string (variable_name, general)
						else
							put_variable (ref_item, variable_name)
						end
				else
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
				if variable_ref.before_last and then Container_features.has (last_step)
					and then attached {FINITE [ANY]} Result as container
				then
					-- is a reference to string/list count or empty status
					if last_step.is_equal (Feature_count) then
						Result := container.count.to_integer_64.to_reference

					elseif last_step.is_equal (Feature_is_empty) then
						Result := container.is_empty.to_reference

					elseif attached {READABLE_INDEXABLE [ANY]} container as indexable then
						if last_step.is_equal (Feature_lower) then
							Result := indexable.lower.to_reference

						elseif last_step.is_equal (Feature_upper) then
							Result := indexable.upper.to_reference
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
			if attached {EVOLICITY_CONTEXT} object
				or else attached {BOOLEAN_REF} object
				or else attached {EL_PATH} object
				or else attached {NUMERIC} object
				or else attached {EVOLICITY_OBJECT_TABLE [EVOLICITY_CONTEXT]} object
				or else attached {ITERABLE [ANY]} object
				or else attached {FINITE [ANY]} object
				or else attached {READABLE_INDEXABLE [ANY]} object
			then
				Result := true
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

	Container_features: ARRAY [STRING]
		once
			Result := << Feature_count, Feature_is_empty, Feature_lower, Feature_upper >>
			Result.compare_objects
		end

end