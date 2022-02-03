note
	description: "Summary description for {EIFFEL_OVERRIDE_FEATURE_EDITOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 10:50:11 GMT (Friday 18th December 2015)"
	revision: "1"

deferred class
	OVERRIDE_FEATURE_EDITOR

inherit
	FEATURE_EDITOR
		redefine
			make
		end

feature {EL_FACTORY_CLIENT} -- Initialization

	make (a_source_path: like source_path)
		do
			Precursor (a_source_path)
			feature_edit_actions := new_feature_edit_actions
		end

feature {NONE} -- Implementation

	edit_feature_group (feature_list: EL_ARRAYED_LIST [CLASS_FEATURE])
		do
			across feature_list as l_feature loop
				feature_edit_actions.search (l_feature.item.name)
				if feature_edit_actions.found then
					feature_edit_actions.found_item.call ([l_feature.item])
				end
			end
		end

feature {NONE} -- Factory

	new_feature_group (export_list, name: ZSTRING): FEATURE_GROUP
		local
			header: EL_ZSTRING_LIST
		do
			create header.make (3)
			if export_list.is_empty then
				header.extend ("feature -- ")
			else
				header.extend (Feature_header_export #$ [export_list])
			end
			header.first.append (name)
			header.extend ("-- AUTO EDITION: new feature group")
			header.extend ("")
			create Result.make (header)
		end

	new_feature_edit_actions: like feature_edit_actions
		deferred
		end

feature {NONE} -- Internal attributes

	feature_edit_actions: EL_ZSTRING_HASH_TABLE [PROCEDURE [CLASS_FEATURE]]

feature {NONE} -- Constants

	Feature_header_export: EL_ZSTRING
		once
			Result := "feature {%S} -- "
		end
end
