skaffoldTags := "tags.json"

# list available receipes
default:
    just --list

build:
    skaffold build -d localhost:5000

publish version:
    #!/usr/bin/env bash
    set -euxo pipefail

    skaffold build -t {{version}} --file-output={{skaffoldTags}}

    LATEST="$(jq -r .builds[0].imageName {{skaffoldTags}}):latest"
    CURRENT="$(jq -r .builds[0].tag {{skaffoldTags}})"

    docker tag $CURRENT $LATEST
    docker push $LATEST
