note
	description: "Hacker intercept configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-24 8:08:58 GMT (Saturday 24th June 2023)"
	revision: "10"

class
	EL_HACKER_INTERCEPT_CONFIG

inherit
	FCGI_SERVICE_CONFIG
		redefine
			building_action_table, make_default
		end

	EL_MODULE_TUPLE

create
	make_default, make_from_file

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			create filter_table.make (5)
		end

feature -- Access

	filter_table: EL_URL_FILTER_TABLE

	block_life_span: INTEGER
		-- max. number of days old for block rule to be preserved from last session

feature {NONE} -- Build from XML

	append_filter (a_predicate: STRING)
		do
			across node.adjusted (False).lines as line loop
				across line.item.split (';') as split loop
					filter_table.extend (a_predicate, split.item_copy)
				end
			end
		end

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		local
			l_xpath: STRING
		do
			Result := Precursor
			Result ["@block_life_span"] := agent do block_life_span := node end
			across filter_table.new_predicate_list as list loop
				l_xpath := Xpath_match_list #$ [list.item]
				Result [l_xpath] := agent append_filter (list.item)
			end
		end

feature {NONE} -- Internal attributes

	Xpath_match_list: ZSTRING
		once
			Result := "match-%S/text()"
		end

end
