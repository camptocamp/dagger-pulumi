package go

import (
	"strings"

	"dagger.io/dagger"
	"universe.dagger.io/bash"
	"universe.dagger.io/go"
)

#Version: {
	source: dagger.#FS

	_command: bash.#Run & {
		_image: go.#Image & {
			packages: bash: _
		}

		input: _image.output

		workdir: "/src"
		script: contents: "go list -m github.com/pulumi/pulumi/sdk/v3 > /version"

		mounts: src: {
			type:     "fs"
			dest:     "/src"
			contents: source
		}

		export: files: "/version": _
	}

	result: strings.TrimPrefix(strings.Split(strings.TrimSpace(_command.export.files."/version"), " ")[1], "v")
}
