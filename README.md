# Copyright Notice

ESnet SmartNIC Copyright (c) 2022, The Regents of the University of
California, through Lawrence Berkeley National Laboratory (subject to
receipt of any required approvals from the U.S. Dept. of Energy),
12574861 Canada Inc., Malleable Networks Inc., and Apical Networks, Inc.
All rights reserved.

If you have questions about your rights to use or distribute this software,
please contact Berkeley Lab's Intellectual Property Office at
IPO@lbl.gov.

NOTICE.  This Software was developed under funding from the U.S. Department
of Energy and the U.S. Government consequently retains certain rights.  As
such, the U.S. Government has been granted for itself and others acting on
its behalf a paid-up, nonexclusive, irrevocable, worldwide license in the
Software to reproduce, distribute copies to the public, prepare derivative
works, and perform publicly and display publicly, and to permit others to do so.


# Support

The ESnet SmartNIC platform is made available in the hope that it will
be useful to the networking community. Users should note that it is
made available on an "as-is" basis, and should not expect any
technical support or other assistance with building or using this
software. For more information, please refer to the LICENSE.md file in
each of the source code repositories.

The developers of the ESnet SmartNIC platform can be reached by email
at smartnic@es.net.


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

