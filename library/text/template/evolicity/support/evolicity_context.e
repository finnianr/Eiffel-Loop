note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-25 22:52:56 GMT (Thursday 25th July 2013)"
	revision: "3"

deferred class
	EVOLICITY_CONTEXT

feature -- Access

	referenced_item (variable_ref: EVOLICITY_VARIABLE_REFERENCE): ANY
			--
		do
			variable_ref.start
			Result := deep_item (variable_ref)
		end

	context_item (var_name: EL_ASTRING; function_args: ARRAY [ANY]): ANY
			--
		do
			Result := objects.item (var_name)
		ensure
			valid_result: attached {ANY} Result as object implies is_valid_type (object)
		end

feature -- Element change

	put_variable (object: ANY; var_name: EL_ASTRING)
			--
		do
			objects.force (object, var_name)
		end

	put_integer_variable (n: INTEGER; var_name: EL_ASTRING)
			--
		do
			objects.force (n.to_real.to_reference, var_name)
		end

	has_variable (var_name: EL_ASTRING): BOOLEAN
			--
		do
			Result := objects.has (var_name)
		end

feature {EVOLICITY_CONTEXT} -- Implementation

	 deep_item (variable_ref: EVOLICITY_VARIABLE_REFERENCE): ANY
			-- Recurse steps of variable referece to find deepest item
		require
			valid_variable_ref: not variable_ref.off
		local
			last_step: EL_ASTRING
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

	objects: EVOLICITY_OBJECT_TABLE [ANY]
			--
		deferred
		end

	is_valid_type (object: ANY): BOOLEAN
			-- object conforms to one of following types

			-- * EVOLICITY_CONTEXT
			-- * STRING
			-- * SEQUENCE [EVOLICITY_CONTEXT]
			-- * SEQUENCE [ANY]
			-- * REAL_REF
		do
			if attached {EVOLICITY_CONTEXT} object as ctx or
			else attached {EL_ASTRING} object as al_string or
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

feature {NONE} -- Constants

	Sequence_features: ARRAY [EL_ASTRING]
		once
			Result := << Feature_count, Feature_is_empty, Feature_lower, Feature_upper >>
			Result.compare_objects
		end

	Feature_count: EL_ASTRING
		once
			Result := "count"
		end

	Feature_is_empty: EL_ASTRING
		once
			Result := "is_empty"
		end

	Feature_lower: EL_ASTRING
		once
			Result := "lower"
		end

	Feature_upper: EL_ASTRING
		once
			Result := "upper"
		end

end
