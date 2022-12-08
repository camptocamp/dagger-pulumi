package go

import (
	"dagger.io/dagger/core"
	"universe.dagger.io/docker"
)

_#Mkdir: self = {
	input: docker.#Image
	path:  string

	_mkdir: core.#Mkdir & {
		input: self.input.rootfs
		path:  self.path
	}

	output: docker.#Image & {
		rootfs: _mkdir.output
		config: input.config
	}
}

#Image: {
	version: string

	docker.#Build & {
		steps: [
			docker.#Pull & {
				source: "docker.io/pulumi/pulumi-go:\(version)-ubi"
			},

			_#Mkdir & {
				path: "/output"
			},

			docker.#Set & {
				config: {
					workdir: "/src"

					entrypoint: [
						"pulumi",
						"--non-interactive",
					]

					env: {
						GOMODCACHE:  "/cache/go/mod"
						GOCACHE:     "/cache/go/build"
						PULUMI_HOME: "/cache/pulumi"
					}
				}
			},
		]
	}
}
