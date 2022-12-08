package pulumi

import (
	"dagger.io/dagger"
	"dagger.io/dagger/core"
	"universe.dagger.io/docker"
)

#Cache: core.#CacheDir & {
	id: "pulumi-cache"
}

#Container: self = {
	image:  docker.#Image | *_image.output
	source: dagger.#FS

	_image: #Image & {
		source: self.source
	}

	docker.#Run & {
		input: self.image

		mounts: {
			source: {
				type:     "fs"
				dest:     "/src"
				contents: self.source
			}

			cache: {
				type:     "cache"
				dest:     "/cache"
				contents: #Cache
			}
		}
	}
}
