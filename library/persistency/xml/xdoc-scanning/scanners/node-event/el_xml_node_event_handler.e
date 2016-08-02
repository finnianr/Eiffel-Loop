note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-24 10:37:57 GMT (Thursday 24th December 2015)"
	revision: "1"

deferred class
	EL_XML_NODE_EVENT_HANDLER

feature {EL_XML_NODE_EVENT_GENERATOR} -- Parsing events

	on_start_document
			--
		deferred
		end

	on_end_document
			--
		deferred
		end

	on_start_tag (node: EL_XML_NODE; attribute_list: EL_XML_ATTRIBUTE_LIST)
			--
		deferred
		end

	on_end_tag (node: EL_XML_NODE)
			--
		deferred
		end

	on_content (node: EL_XML_NODE)
			--
		deferred
		end

	on_comment (node: EL_XML_NODE)
			--
		deferred
		end

	on_processing_instruction (node: EL_XML_NODE)
			--
		deferred
		end
end