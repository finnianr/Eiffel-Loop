note
	description: "Evolicity context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-14 7:03:04 GMT (Friday 14th March 2025)"
	revision: "21"

deferred class
	EVOLICITY_CONTEXT

inherit
	ANY

	EL_STRING_GENERAL_ROUTINES

feature -- Access

	context_item (variable_ref: EVOLICITY_VARIABLE_REFERENCE; index: INTEGER): ANY
			--
		do
			Result := object_table [variable_ref [index]]
		ensure
			valid_result: attached Result as object implies is_valid_type (object)
		end

	referenced_item (variable_ref: EVOLICITY_VARIABLE_REFERENCE): ANY
			--
		do
			variable_ref.set_context (Current)
			Result := recursive_item (variable_ref, 1)
		end

feature -- Status query

	has_variable (variable_name: READABLE_STRING_8): BOOLEAN
			--
		do
			Result := object_table.has (variable_name)
		end

feature -- Element change

	put_boolean (variable_name: READABLE_STRING_8; value: BOOLEAN)
			--
		do
			put_any (variable_name, value.to_reference)
		end

	put_double (variable_name: READABLE_STRING_8; value: DOUBLE)
			--
		do
			put_any (variable_name, value.to_reference)
		end

	put_integer (variable_name: READABLE_STRING_8; value: INTEGER)
			--
		do
			put_any (variable_name, value.to_reference)
		end

	put_natural (variable_name: READABLE_STRING_8; value: NATURAL)
			--
		do
			put_any (variable_name, value.to_reference)
		end

	put_quoted_string (variable_name: READABLE_STRING_8; a_string: READABLE_STRING_GENERAL; count: INTEGER)
		do
			put_string (variable_name, as_zstring (a_string).quoted (count))
		end

	put_real (variable_name: READABLE_STRING_8; value: REAL)
			--
		do
			put_any (variable_name, value.to_reference)
		end

	put_string (variable_name: READABLE_STRING_8; value: READABLE_STRING_GENERAL)
		do
			put_any (variable_name, as_zstring (value))
		end

	put_any (variable_name: READABLE_STRING_8; object: ANY)
			-- the order (value, variable_name) is special case due to function_item assign in descendant
		do
			object_table [variable_name] := object
		end

	put_variables (name_value_pair_list: ARRAY [TUPLE])
			--
		require
			valid_tuples:
				across name_value_pair_list as tuple all
					tuple.item.count = 2 and then attached {READABLE_STRING_GENERAL} tuple.item.reference_item (1)
				end
		do
			across name_value_pair_list as list loop
				if attached list.item as pair
					and then attached {READABLE_STRING_GENERAL} pair.reference_item (1) as general
					and then attached general.to_string_8 as variable_name
				then
					inspect pair.item_code (2)
						when {TUPLE}.Character_8_code then
							put_any (variable_name, pair.character_8_item (2).out)

						when {TUPLE}.Character_32_code then
							put_any (variable_name, pair.character_32_item (2).out)

						when {TUPLE}.Boolean_code then
							put_boolean (variable_name, pair.boolean_item (2))

						when {TUPLE}.Integer_8_code then
							put_integer (variable_name, pair.integer_8_item (2))

						when {TUPLE}.Integer_16_code then
							put_integer (variable_name, pair.integer_16_item (2))

						when {TUPLE}.Integer_32_code then
							put_integer (variable_name, pair.integer_32_item (2))

						when {TUPLE}.Integer_64_code then
							put_any (variable_name, pair.integer_64_item (2).to_reference)

						when {TUPLE}.Natural_8_code then
							put_natural (variable_name, pair.natural_8_item (2))

						when {TUPLE}.Natural_16_code then
							put_natural (variable_name, pair.natural_16_item (2))

						when {TUPLE}.Natural_32_code then
							put_natural (variable_name, pair.natural_32_item (2))

						when {TUPLE}.Natural_64_code then
							put_any (variable_name, pair.natural_64_item (2).to_reference)

						when {TUPLE}.Real_32_code then
							put_real (variable_name, pair.real_32_item (2))

						when {TUPLE}.Real_64_code then
							put_double (variable_name, pair.real_64_item (2))

						when {TUPLE}.Reference_code then
							if attached pair.reference_item (2) as ref_item then
								if attached {READABLE_STRING_GENERAL} ref_item as str then
									 put_string (variable_name, str)
								else
									put_any (variable_name, ref_item)
								end
							end
					else
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

	 recursive_item (variable_ref: EVOLICITY_VARIABLE_REFERENCE; index: INTEGER): ANY
			-- Recurse steps of variable reference to find deepest item
		require
			valid_index: variable_ref.valid_index (index)
		local
			index_end: INTEGER
		do
			index_end := variable_ref.count
			Result := context_item (variable_ref, index)
			if index < index_end then
				if index = (index_end - 1) and then Feature_table.has_key (variable_ref [index_end])
					and then attached {FINITE [ANY]} Result as container
				then
					-- is a reference to string/list count or empty status
					inspect Feature_table.found_item
						when Feature_count then
							Result := container.count.to_integer_64.to_reference

						when Feature_is_empty then
							Result := container.is_empty.to_reference

						when Feature_lower, Feature_upper then
							if attached {READABLE_INDEXABLE [ANY]} container as indexable then
								if Feature_table.found_item = Feature_lower then
									Result := indexable.lower.to_reference
								else
									Result := indexable.upper.to_reference
								end
							elseif attached {EVOLICITY_CONTEXT} Result as l_context then
								Result := l_context.recursive_item (variable_ref, index + 1)
							end
					end

				elseif attached {EVOLICITY_CONTEXT} Result as l_context then
					Result := l_context.recursive_item (variable_ref, index + 1)
				end
			end
		end

feature {EVOLICITY_COMPOUND_DIRECTIVE} -- Implementation

	is_valid_iterable (iterable: ITERABLE [ANY]): BOOLEAN
		-- `True' if iterable object has valid items
		local
			inspected: BOOLEAN
		do
			if attached {TABLE_ITERABLE [ANY, HASHABLE]} iterable as table_iterable  then
				across table_iterable as table until inspected loop
					Result := is_valid_type (table.item) and is_valid_type (table.key)
					inspected := True
				end
			else
				across iterable as list until inspected loop
					Result := is_valid_type (list.item)
					inspected := True
				end
			end
			if not inspected then
				Result := True
			end
		end

	is_valid_type (object: ANY): BOOLEAN
			-- object conforms to one of following types
		do
			Result := Valid_types.has_conforming (object)
		end

	object_table: EL_STRING_8_TABLE [ANY]
		deferred
		end

	valid_types_tuple: TUPLE [
		BOOLEAN_REF,
		DATE, DATE_TIME,
		EVOLICITY_CONTEXT, EVOLICITY_FUNCTION_TABLE,
		EL_PATH,
		FUNCTION [ANY],
		NUMERIC,
		READABLE_STRING_GENERAL,
		TIME,
--		Collections
		ITERABLE [ANY], FINITE [ANY], READABLE_INDEXABLE [ANY], EL_STRING_8_TABLE [EVOLICITY_CONTEXT]
	]
		do
			create Result
		end

feature {NONE} -- Enumeration

	Feature_count: INTEGER = 1

	Feature_is_empty: INTEGER = 2

	Feature_lower: INTEGER = 3

	Feature_upper: INTEGER = 4

feature {NONE} -- Constants

	Feature_table: EL_HASH_TABLE [INTEGER, STRING]
		once
			create Result.make_assignments (<<
				["count",	 Feature_count],
				["is_empty", Feature_is_empty],
				["lower",	 Feature_lower],
				["upper",	 Feature_upper]
			>>)
		end

	Valid_types: EL_TYPE_ID_ARRAY
		once
			create Result.make_from_tuple (valid_types_tuple)
		end

end