package pulumi

import (
	"github.com/camptocamp/pulumi-aws-schweizmobil/ci/pulumi/go"

	"dagger.io/dagger"
)

#Version: self = {
	source: dagger.#FS
	result: string

	_runtime: #Runtime & {
		source: self.source
	}

	// TODO
	// Use conditional include based on runtime once its supported.
	go.#Version
}
