note
	description: "Xpath token table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-29 13:49:07 GMT (Tuesday 29th December 2020)"
	revision: "7"

class
	EL_XPATH_TOKEN_TABLE

inherit
	HASH_TABLE [INTEGER_16, STRING_32]
		redefine
			default_create --, extend, put
		end

	EL_XPATH_CONSTANTS
		undefine
			default_create, is_equal, copy
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
		do
			make_equal (23)
			extend (Child_element_step_id, Node_any)
			extend (Descendant_or_self_node_step_id, Node_descendant_or_self)
			extend (Comment_node_step_id.to_integer_16, Node_comment)
			extend (Text_node_step_id.to_integer_16, Node_text)
		end

feature -- Element change

--	extend (new: INTEGER_16; key: STRING_32)
--		local
--			template: EL_ASTRING
--		do
--			log.enter ("extend")
--			template := "extend (%S,%"%S%")"
--			log.put_line (template #$ [new, key])
--			Precursor (new, key)
--			log.exit
--		end

--	put (new: INTEGER_16; key: STRING_32)
--		local
--			template: EL_ASTRING
--		do
--			log.enter ("put")
--			template := "put (%S,%"%S%")"
--			log.put_line (template #$ [new, key])
--			Precursor (new, key)
--			log.put_integer_field ("count", count)
--			log.exit
--		end

end