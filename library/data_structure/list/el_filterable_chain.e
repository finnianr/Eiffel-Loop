note
	description: "Summary description for {EL_FILTERABLE_CHAIN}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-01-07 17:18:56 GMT (Monday 7th January 2013)"
	revision: "2"

deferred class EL_FILTERABLE_CHAIN [G]

inherit
	CHAIN [G]

feature {NONE} -- Initialization

	make_filterable
		do
			create positive_criteria.make (5)
			create negative_criteria.make (5)
			set_default_criteria
		end

feature -- Access

	query_results: ARRAYED_LIST [G]
			-- songs matching criteria
		do
			create Result.make (count)
			from start until after loop
				if fits_all (item, positive_criteria) and not fits_any (item, negative_criteria) then
					Result.extend (item)
				end
				forth
			end
		end

	positive_critera_count: INTEGER
		do
			Result := positive_criteria.count
		end

	negative_critera_count: INTEGER
		do
			Result := negative_criteria.count
		end

feature -- Element change

	reset_criteria
		do
			positive_criteria.wipe_out
			negative_criteria.wipe_out
		end

	set_default_criteria
			--
		do
			reset_criteria
		end

	set_criteria_with_default (a_criteria: like positive_criteria.item)
			--
		do
			set_default_criteria
			positive_criteria.extend (a_criteria)
		end

	add_criteria (a_criteria: like positive_criteria.item)
			--
		do
			positive_criteria.extend (a_criteria)
		end

	add_negative_criteria (a_criteria: like positive_criteria.item)
			--
		do
			negative_criteria.extend (a_criteria)
		end

	add_all_criteria (a_criterias: ARRAY [like positive_criteria.item])
			--
		do
			a_criterias.do_all (agent add_criteria)
		end

	add_all_negative_criteria (a_criterias: ARRAY [like positive_criteria.item])
			--
		do
			a_criterias.do_all (agent add_negative_criteria)
		end

feature {NONE} -- Implementation

	fits_all (v: like item; criteria: like positive_criteria): BOOLEAN
			--
		do
			Result := True
			from criteria.start until not Result or criteria.after loop
				Result := Result and criteria.item.item ([v])
				criteria.forth
			end
		end

	fits_any (v: like item; criteria: like positive_criteria): BOOLEAN
			--
		do
			from criteria.start until Result or criteria.after loop
				Result := criteria.item.item ([v])
				criteria.forth
			end
		end

	positive_criteria: ARRAYED_LIST [PREDICATE [ANY, TUPLE [G]]]

	negative_criteria: like positive_criteria

end
