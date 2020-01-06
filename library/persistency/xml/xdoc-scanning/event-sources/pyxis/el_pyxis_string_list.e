note
	description: "Pyxis string list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-18 12:37:28 GMT (Friday 18th January 2019)"
	revision: "5"

deferred class
	EL_PYXIS_STRING_LIST

inherit
	EL_BUILDABLE_FROM_PYXIS
		redefine
			building_action_table
		end

feature -- Element change

	extend (str: ZSTRING)
		deferred
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result.make (<<
				[item_xpath, agent do extend (node.to_string) end]
			>>)
		end

	item_xpath: STRING
		do
			Result := "item/text()"
		end

end
