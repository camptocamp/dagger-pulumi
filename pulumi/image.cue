package pulumi

import (
	"github.com/camptocamp/pulumi-aws-schweizmobil/ci/pulumi/go"

	"dagger.io/dagger"
	"universe.dagger.io/docker"
)

#Image: self = {
	source?:  dagger.#FS
	runtime?: string
	version?: string
	output:   docker.#Image

	if self.source != _|_ {
		runtime: _runtime.result
		version: _version.result

		_runtime: #Runtime & {
			source: self.source
		}

		_version: #Version & {
			source: self.source
		}
	}

	// TODO
	// Use conditional include based on runtime once its supported.
	go.#Image
}
