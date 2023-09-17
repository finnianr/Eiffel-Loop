note
	description: "Eiffel keyword constants using [$source EL_IMMUTABLE_STRING_8_TABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-15 14:58:25 GMT (Friday 15th September 2023)"
	revision: "1"

deferred class
	EL_EIFFEL_IMMUTABLE_KEYWORDS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Keyword_type_table: EL_IMMUTABLE_STRING_8_TABLE
		-- lookup
		local
			interval_table: HASH_TABLE [INTEGER_64, IMMUTABLE_STRING_8]
		once
		-- deferred is not categorized as a routine because it contains no code
			create Result.make_by_assignment ("[
				across := block
				agent := kw
				alias := kw
				all := block
				and := operator
				as := kw
				assign := kw
				attached := kw
				attribute := kw
				check := debug
				class := kw
				convert := kw
				create := kw
				current := reference
				debug := debug
				deferred := kw
				detachable := kw
				do := routine
				else := kw
				elseif := kw
				end := end_block
				ensure := end_block
				expanded := kw
				export := inheritance
				external := external
				false := constant
				feature := note
				from := block
				frozen := kw
				if := block
				implies := operator
				indexing := note
				inherit := inheritance
				inspect := block
				invariant := contract
				like := kw
				local := kw
				loop := kw
				not := operator
				note := note
				obsolete := note
				old := operator
				once := routine
				only := kw
				or := operator
				precursor := kw
				redefine := inheritance
				rename := inheritance
				require := contract
				rescue := kw
				result := reference
				retry := kw
				select := inheritance
				separate := kw
				then := kw
				true := constant
				undefine := inheritance
				until := kw
				variant := contract
				void := constant
				when := kw
				xor := operator
			]")

--			ensure unique keyword types use the same immutable string interval to facilitate
--			`Type_*' constants
			create interval_table.make (31)
			from Result.start until Result.after loop
				interval_table.put (Result.interval_item_for_iteration, Result.item_for_iteration)
				if interval_table.conflict then
					Result.force (interval_table.found_item, Result.key_for_iteration)
				end
				Result.forth
			end
		end

feature {NONE} -- Keyword types

	Type_block: INTEGER_64
		-- indicates block of statements
		once
			if Keyword_type_table.has_key_8 ("if") then
				Result := Keyword_type_table.found_interval
			end
		ensure
			same_type:
				across ("inspect,from,across").split (',') as word all
					Keyword_type_table.has_key_8 (word.item) implies Keyword_type_table.found_interval = Result
				end
		end

	Type_debug: INTEGER_64
		-- indicates block of statements for debugging
		once
			if Keyword_type_table.has_key_8 ("debug") then
				Result := Keyword_type_table.found_interval
			end
		ensure
			same_type:
				Keyword_type_table.has_key_8 ("check") implies Keyword_type_table.found_interval = Result
		end

	Type_end_block: INTEGER_64
		-- indicates end of block of statements
		once
			if Keyword_type_table.has_key_8 ("end") then
				Result := Keyword_type_table.found_interval
			end
		ensure
			same_type:
				Keyword_type_table.has_key_8 ("ensure") implies Keyword_type_table.found_interval = Result
		end

	Type_external: INTEGER_64
		-- external routine
		once
			if Keyword_type_table.has_key_8 ("external") then
				Result := Keyword_type_table.found_interval
			end
		end

	Type_note: INTEGER_64
		-- some kind of purely informational note
		once
			if Keyword_type_table.has_key_8 ("note") then
				Result := Keyword_type_table.found_interval
			end
		ensure
			same_type:
				across ("indexing,feature,obsolete").split (',') as word all
					Keyword_type_table.has_key_8 (word.item) implies Keyword_type_table.found_interval = Result
				end
		end

	Type_operator: INTEGER_64
		-- operator keyword
		once
			if Keyword_type_table.has_key_8 ("or") then
				Result := Keyword_type_table.found_interval
			end
		ensure
			same_type:
				across ("and,old,implies,not,xor").split (',') as word all
					Keyword_type_table.has_key_8 (word.item) implies Keyword_type_table.found_interval = Result
				end
		end

	Type_routine: INTEGER_64
		-- indicates start of routine
		once
			if Keyword_type_table.has_key_8 ("do") then
				Result := Keyword_type_table.found_interval
			end
		ensure
			same_type: Keyword_type_table.has_key_8 ("once") implies Keyword_type_table.found_interval = Result
		end

end
