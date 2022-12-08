package pulumi

import (
	"dagger.io/dagger"
	"dagger.io/dagger/core"
)

#Refresh: {
	stack: string
	diff:  bool | *false

	#Command & {
		name: "refresh"

		args: [
			"--stack",
			stack,

			if diff {
				"--diff"
			},

			"--skip-preview",
		]
	}
}

#Preview: self = {
	stack: string
	diff:  bool | *false

	#Command & {
		name: "preview"

		args: [
			"--stack",
			stack,
			"--save-plan",
			"/output/plan.json",

			if diff {
				"--diff"
			},
		]
	}

	_file: core.#ReadFile & {
		input: self.output
		path:  "plan.json"
	}

	plan: _file.contents
}

#Update: {
	stack: string
	diff:  bool | *false
	plan:  string

	_file: core.#WriteFile & {
		input:    dagger.#Scratch
		path:     "plan.json"
		contents: plan
	}

	#Command & {
		name: "update"

		args: [
			"--stack",
			stack,
			// FIXME
			// Using plan doesn’t work reliably enough at the time
			// "--plan",
			// "/input/plan.json",

			if diff {
				"--diff"
			},

			"--skip-preview",
		]

		input: _file.output
	}
}

#Destroy: {
	stack: string
	diff:  bool | *false

	#Command & {
		name: "destroy"

		args: [
			"--stack",
			stack,

			if diff {
				"--diff"
			},

			"--skip-preview",
		]
	}
}
