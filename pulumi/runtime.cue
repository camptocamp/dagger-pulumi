package pulumi

import (
	"dagger.io/dagger"
)

#Runtime: self = {
	source: dagger.#FS
	result: string

	_config: #Config & {
		source: self.source
	}

	result: _config.result.runtime.name | _config.result.runtime
}
