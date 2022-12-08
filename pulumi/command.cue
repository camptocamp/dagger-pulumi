package pulumi

import (
	"dagger.io/dagger"
	"universe.dagger.io/bash"
	"universe.dagger.io/docker"
)

#Command: self = {
	image?: docker.#Image
	name:   string
	args: [...string]
	env: [string]: string
	source: dagger.#FS
	input?: dagger.#FS

	_forceRun: bash.#RunSimple & {
		script: contents: "true"
		always: true
	}

	_container: #Container & {
		if self.image != _|_ {
			image: self.image
		}

		source: self.source

		command: {
			name: self.name
			args: self.args
		}

		env: self.env & {
			FORCE_RUN_HACK: "\(_forceRun.success)"
		}

		if self.input != _|_ {
			mounts: input: {
				type:     "fs"
				dest:     "/input"
				contents: self.input
			}
		}

		export: directories: "/output": _
	}

	output: _container.export.directories."/output"
}
