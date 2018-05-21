note
	description: "Evolicity context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:06 GMT (Saturday 19th May 2018)"
	revision: "4"

deferred class
	EVOLICITY_CONTEXT

feature -- Access

	context_item (variable_name: ZSTRING; function_args: ARRAY [ANY]): ANY
			--
		do
			Result := objects.item (variable_name)
		ensure
			valid_result: attached {ANY} Result as object implies is_valid_type (object)
		end

	referenced_item (variable_ref: EVOLICITY_VARIABLE_REFERENCE): ANY
			--
		do
			variable_ref.start
			Result := deep_item (variable_ref)
		end

feature -- Element change

	has_variable (variable_name: ZSTRING): BOOLEAN
			--
		do
			Result := objects.has (variable_name)
		end

	put_integer (variable_name: ZSTRING; value: INTEGER)
			--
		do
			objects.force (value.to_reference, variable_name)
		end

	put_variable (object: ANY; variable_name: ZSTRING)
			-- the order (value, variable_name) is special case due to function_item assign in descendant
		do
			objects.force (object, variable_name)
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
			last_step: ZSTRING
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

	objects: EVOLICITY_OBJECT_TABLE [ANY]
			--
		deferred
		end

feature {NONE} -- Constants

	Feature_count: ZSTRING
		once
			Result := "count"
		end

	Feature_is_empty: ZSTRING
		once
			Result := "is_empty"
		end

	Feature_lower: ZSTRING
		once
			Result := "lower"
		end

	Feature_upper: ZSTRING
		once
			Result := "upper"
		end

	Sequence_features: ARRAY [ZSTRING]
		once
			Result := << Feature_count, Feature_is_empty, Feature_lower, Feature_upper >>
			Result.compare_objects
		end

end
