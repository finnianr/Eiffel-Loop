note
	description: "Summary description for {EL_XPATH_TOKEN_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "3"

class
	EL_XPATH_TOKEN_TABLE

inherit
	HASH_TABLE [INTEGER_16, STRING_32]
		redefine
			default_create --, extend, put
		end

	EL_XPATH_TOKEN_CONSTANTS
		undefine
			default_create, is_equal, copy
		end

--	EL_MODULE_LOG
--		undefine
--			default_create, is_equal, copy
--		end

create
	default_create

feature {NONE} -- Initialization

	default_create
		do
			make_equal (23)
			extend (Child_element_step_id, Child_element)
			extend (Descendant_or_self_node_step_id, Descendant_or_self_node)
			extend (Comment_node_step_id.to_integer_16, Comment_node)
			extend (Text_node_step_id.to_integer_16, Text_node)
		end

feature -- Element change

--	extend (new: INTEGER_16; key: STRING_32)
--		local
--			template: EL_ASTRING
--		do
--			log.enter ("extend")
--			template := "extend ($S,%"$S%")"
--			log.put_line (template #$ [new, key])
--			Precursor (new, key)
--			log.exit
--		end

--	put (new: INTEGER_16; key: STRING_32)
--		local
--			template: EL_ASTRING
--		do
--			log.enter ("put")
--			template := "put ($S,%"$S%")"
--			log.put_line (template #$ [new, key])
--			Precursor (new, key)
--			log.put_integer_field ("count", count)
--			log.exit
--		end

end
