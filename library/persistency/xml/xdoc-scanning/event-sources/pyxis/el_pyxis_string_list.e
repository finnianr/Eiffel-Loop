note
	description: "Summary description for {EL_PYXIS_STRING_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "4"

deferred class
	EL_PYXIS_STRING_LIST

inherit
	EL_BUILDABLE_FROM_PYXIS
		redefine
			building_action_table
		end

feature -- Element change

	extend (str: ASTRING)
		deferred
		end

feature {NONE} -- Build from XML

	building_action_table: like Type_building_actions
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
