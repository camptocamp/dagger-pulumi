package pulumi

import (
	"encoding/yaml"

	"dagger.io/dagger"
	"dagger.io/dagger/core"
)

#Config: {
	source: dagger.#FS

	_file: core.#ReadFile & {
		input: source
		path:  "Pulumi.yaml"
	}

	result: yaml.Unmarshal(_file.contents)
}
