note
	description: "Encrypted search engine test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-27 13:27:21 GMT (Wednesday 27th February 2019)"
	revision: "1"

class
	ENCRYPTED_SEARCH_ENGINE_TEST_EVALUATOR

inherit
	SEARCH_ENGINE_TEST_EVALUATOR
		redefine
			item
		end

feature {NONE} -- Internal attributes

	item: ENCRYPTED_SEARCH_ENGINE_TEST_SET

end
