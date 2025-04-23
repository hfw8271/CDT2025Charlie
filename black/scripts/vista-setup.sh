incus init windows-vista --empty --vm -d root,size=50GiB
incus config set windows-vista limits.memory=2GB
incus config set windows-vista limits.cpu=2
incus config set windows-vista migration.stateful=false
incus config set windows-vista image.os=Windows
incus config set windows-vista security.csm=true
incus config set windows-vista security.secureboot=false
incus config device add windows-vista vista-volume disk pool=default source=vista-volume boot.priority=10
incus config device add windows-vista virtio-iso disk pool=default source=virtio-iso boot.priority=5
