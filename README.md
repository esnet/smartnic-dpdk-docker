
Building the smartnic-dpdk-docker container
-------------------------------------------

```
docker build --pull -t smartnic-dpdk-docker:${USER}-dev .
docker image ls
```

You should see an image called `smartnic-dpdk-docker` with tag `${USER}-dev`.

Building in isolated environments
---------------------------------

These steps are **only** relevant if your image build environment has limited or zero access to the Internet.  Do **not** run these commands if the simple build steps in the previous section work for you.

This example shows how to override locations of various resources needed in the build:
```
docker build --pull -t smartnic-dpdk-docker:${USER}-dev \
   --build-arg DOCKERHUB_PROXY="wharf.es.net/dockerhub-proxy/" \
   --build-arg DPDK_BASE_URL="https://dispense.es.net/dpdk" \
   --build-arg PKTGEN_BASE_URL="https://dispense.es.net/dpdk" .
```
`DOCKERHUB_PROXY`: Prefix server/path to use when pulling public images.  **Note** the trailing `/` on this definition.
`DPDK_BASE_URL`: Alternate base URL to use when fetching the DPDK tar file.  Useful if you choose to locally host the file.
`PKTGEN_BASE_URL`: Alternate base URL to use when fetching the pktgen tar file.  Useful if you choose to locally host the file.

