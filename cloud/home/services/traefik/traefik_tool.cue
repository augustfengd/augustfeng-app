package traefik

import (
	"path"
	"tool/http"
	"tool/exec"

	"github.com/augustfengd/augustfeng.app/cue.lib/tools:git"
	"github.com/augustfengd/augustfeng.app/cue.lib/tools:kubectl"
)

manifests: [
	namespace.manifests,
	crd.manifests,
	serviceaccount.manifests,
	clusterroles.manifests,
	clusterrolebinding.manifests,
	cm.manifests,
	deployment.manifests,
	ingressroute.manifests,
]

command: kubectl & {
	#namespace: "system-ingress"
	#manifests: manifests
}

command: crd: {
	root: git.#root

	get: http.Get & {
		request: body: ""
		url: "https://raw.githubusercontent.com/traefik/traefik/v3.1.1/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml"
	}

	import: exec.Run & {
		outfile: path.FromSlash("cloud/home/services/traefik/crd.cue", "unix")
		stdin:   get.response.body
		cmd:     "cue import -f --list --path crd:manifests: -p traefik -o \(outfile) yaml: -"
		dir:     root.dir
	}
}
