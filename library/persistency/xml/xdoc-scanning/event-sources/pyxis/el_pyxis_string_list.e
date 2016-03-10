note
	description: "Summary description for {EL_PYXIS_STRING_LIST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_PYXIS_STRING_LIST

inherit
	EL_BUILDABLE_FROM_PYXIS
		redefine
			building_action_table
		end

feature -- Element change

	extend (str: EL_ASTRING)
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
