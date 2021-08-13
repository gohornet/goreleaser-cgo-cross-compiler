# GoReleaser CGO Cross Compiler with musl

[![Software License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=for-the-badge)](/LICENSE)

This is a Docker container to be able to cross compile Golang packages with enabled cgo together with [GoReleaser](https://goreleaser.com/).

### Supported OS and architectures:

- Windows (amd64)
- Linux (amd64, ARM64)
- macOS (amd64) **No CGO support**

### Used versions

- **GoLang**: 1.16.7
- **GoReleaser**: 0.174.2
- **Docker**: 20.10.8
- **MUSL**: 2021-03-04 Release

### Docker

[Docker hub](https://hub.docker.com/r/gohornet/goreleaser-cgo-cross-compiler)

```Docker
docker run --rm --privileged \
  -v $PWD:/go/src/github.com/[project]/[repo] \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -w /go/src/github.com/[project]/[repo] \
  gohornet/goreleaser-cgo-cross-compiler:latest goreleaser --snapshot --rm-dist
```
