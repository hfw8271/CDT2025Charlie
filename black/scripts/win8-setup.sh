incus init Velociraptor --empty --vm -d root,size=60GiB
incus config set Velociraptor limits.memory=2GB
incus config set Velociraptor migration.stateful=false
incus config set Velociraptor image.os=Windows
incus config set Velociraptor security.csm=true
incus config set Velociraptor security.secureboot=false
incus config device add Velociraptor eight-volume disk pool=default source=eight-volume boot.priority=10
incus config device add Velociraptor virtio-iso disk pool=default source=virtio-iso boot.priority=5
