package ci

import (
	"github.com/camptocamp/pulumi-aws-schweizmobil/ci/pulumi"

	"dagger.io/dagger"
	"universe.dagger.io/bash"
)

#Pulumi: self = {
	env: [string]: string
	source: dagger.#FS
	stack:  string
	diff:   bool
	update: plan: string
	enableDestructiveActions: bool | *false

	_commands: {
		[string]: {
			image:  _image.output
			env:    self.env
			source: self.source
			stack:  self.stack
			diff:   self.diff

			// TODO:
			// Use docker.#Build once structural cycle detection has been fixed
			_baseImage: pulumi.#Image & {
				source: self.source
			}

			_image: bash.#Run & {
				input: _baseImage.output
				script: contents: """
					microdnf install unzip
					tmpdir=$(mktemp -d)
					cd $tmpdir
					curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.7.35.zip -o awscli.zip
					unzip awscli.zip
					./aws/install
					cd -
					rm -rf $tmpdir
					microdnf remove unzip
					microdnf clean all
					"""
			}
		}

		refresh: pulumi.#Refresh
		preview: pulumi.#Preview

		if enableDestructiveActions {
			update:  pulumi.#Update & self.update
			destroy: pulumi.#Destroy
		}
	}

	commands: {
		for k, v in _commands {
			"\(k)": v
		}
	}
}
