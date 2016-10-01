# Hands-on Rundeck

Voraussetzungen:

* [Vagrant](https://www.vagrantup.com/downloads.html)
* [Virtualbox](https://www.virtualbox.org/wiki/Downloads)
* Virtualisierungsfunktion Intel VT-x im Bios aktiviert
* 6 GB freien Arbeitsspeicher (für alle VMs)

Alle VMs hochfahren:

```bash
cd vms
vagrant up
```

Demo-Anwendung: https://github.com/grafjo/devops-meetup-rundeck-demo


## Zugangsdaten

### Rundeck

URL: http://192.168.33.50:4440
Benutzer: admin / admin

SSH: vagrant ssh rundeck

### Jenkins

URL: http://192.168.33.51:8080

TODO:
* "Empfohlene Plugins" installieren
* Rundeck Plugin installieren

SSH: vagrant ssh jenkins

### Nexus

URL: http://192.168.33.52:8081
Benutzer: admin / admin123

SSH: vagrant ssh nexus

### Test

URL: http://192.168.33.61:8080/info oder /health

SSH: vagrant ssh test


## Einführung

Vagrant Private SSH-Key als Private-Key (Name: meetup) in Rundeck unter
http://192.168.33.50:4440/menu/storage ablegen:

```
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzI
w+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoP
kcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2
hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NO
Td0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcW
yLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQIBIwKCAQEA4iqWPJXtzZA68mKd
ELs4jJsdyky+ewdZeNds5tjcnHU5zUYE25K+ffJED9qUWICcLZDc81TGWjHyAqD1
Bw7XpgUwFgeUJwUlzQurAv+/ySnxiwuaGJfhFM1CaQHzfXphgVml+fZUvnJUTvzf
TK2Lg6EdbUE9TarUlBf/xPfuEhMSlIE5keb/Zz3/LUlRg8yDqz5w+QWVJ4utnKnK
iqwZN0mwpwU7YSyJhlT4YV1F3n4YjLswM5wJs2oqm0jssQu/BT0tyEXNDYBLEF4A
sClaWuSJ2kjq7KhrrYXzagqhnSei9ODYFShJu8UWVec3Ihb5ZXlzO6vdNQ1J9Xsf
4m+2ywKBgQD6qFxx/Rv9CNN96l/4rb14HKirC2o/orApiHmHDsURs5rUKDx0f9iP
cXN7S1uePXuJRK/5hsubaOCx3Owd2u9gD6Oq0CsMkE4CUSiJcYrMANtx54cGH7Rk
EjFZxK8xAv1ldELEyxrFqkbE4BKd8QOt414qjvTGyAK+OLD3M2QdCQKBgQDtx8pN
CAxR7yhHbIWT1AH66+XWN8bXq7l3RO/ukeaci98JfkbkxURZhtxV/HHuvUhnPLdX
3TwygPBYZFNo4pzVEhzWoTtnEtrFueKxyc3+LjZpuo+mBlQ6ORtfgkr9gBVphXZG
YEzkCD3lVdl8L4cw9BVpKrJCs1c5taGjDgdInQKBgHm/fVvv96bJxc9x1tffXAcj
3OVdUN0UgXNCSaf/3A/phbeBQe9xS+3mpc4r6qvx+iy69mNBeNZ0xOitIjpjBo2+
dBEjSBwLk5q5tJqHmy/jKMJL4n9ROlx93XS+njxgibTvU6Fp9w+NOFD/HvxB3Tcz
6+jJF85D5BNAG3DBMKBjAoGBAOAxZvgsKN+JuENXsST7F89Tck2iTcQIT8g5rwWC
P9Vt74yboe2kDT531w8+egz7nAmRBKNM751U/95P9t88EDacDI/Z2OwnuFQHCPDF
llYOUI+SpLJ6/vURRbHSnnn8a/XG+nzedGH5JGqEJNQsz+xT2axM0/W/CRknmGaJ
kda/AoGANWrLCz708y7VYgAtW2Uf1DPOIYMdvo6fxIB5i9ZfISgcJ/bbCUkFrhoH
+vq/5CIWxCPp0f85R4qxxQ5ihxJ0YDQT9Jpx4TMss4PSavPaBH3RXow5Ohe+bYoQ
NE5OgEXk2wVfZczCZpigBKbKZHNYcelXtTt/nP3rsCuGcM4h53s=
-----END RSA PRIVATE KEY-----
```

Node Liste für Meetup-Projekt unter `/var/lib/rundeck/projects/meetup/etc/resources.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project>
  <node name="localhost" description="Rundeck server node" tags="" hostname="localhost" osArch="amd64" osFamily="unix" osName="Linux" osVersion="3.16.0-4-amd64" username="rundeck"/>
  <node name="test" description="meetup demo test node" tags="meetup,test" hostname="192.168.33.61" osArch="amd64" osFamily="Debian" osName="Debian" osVersion="jessie" username="vagrant"/>
  <node name="stage" description="meetup demo stage node" tags="meetup,stage" hostname="192.168.33.62" osArch="amd64" osFamily="Debian" osName="Debian" osVersion="jessie" username="vagrant"/>
  <node name="prod" description="meetup demo prod node" tags="meetup,prod" hostname="192.168.33.63" osArch="amd64" osFamily="Debian" osName="Debian" osVersion="jessie" username="vagrant"/>
</project>
```


## Deployment Pipeline

### Node Suche

Unter http://192.168.33.50:4440/project/meetup/nodes

* Alle Nodes anzeigen: `.*`
* Node nach Name `name: test`
* Node nach Tag `tags: test`
* Ausdruck negieren `!tags: test`
* Order verknüpfen: `tags: test|stage`


### Jobs

Auf http://192.168.33.50:4440/project/meetup/jobs über `Job Actions -> Upload Definition ...` die Jobs hochladen

* [deployment-demo](jobs/deployment-demo-version.xml)
* [service-demo](jobs/service-demo-version.xml)
* [service-ssh](jobs/service-ssh-version.xml)


## ACLs

ACLs via SSH konfigurieren

```bash
vagrant ssh rundeck
sudo su -
```

### acl für meetup projekt

```bash
rd-acl create -c application -g deploy -p meetup -a read >> /etc/rundeck/deploy.aclpolicy
```

### acl für meetup ssh-key

```bash
rd-acl create -c application -g deploy -s meetup -a read >> /etc/rundeck/deploy.aclpolicy
```

### rd-acl list vorstellen

```bash
rd-acl list -g deploy -p meetup| more
```

### Job deploy-demo

```bash
rd-acl test -c project -g deploy -p meetup -j deploy-demo
rd-acl test -c project -g deploy -p meetup -j deploy-demo -a read,run,kill
rd-acl test -c project -g deploy -p meetup -j deploy-demo -a read,run,kill -v
rd-acl create -c project -g deploy -p meetup -j deploy-demo -a read,run,kill
rd-acl create -c project -g deploy -p meetup -j deploy-demo -a read,run,kill >> /etc/rundeck/deploy.aclpolicy
rd-acl test -c project -g deploy -p meetup -j deploy-demo -a read,run,kill -v
```

### Job service-demo

```bash
rd-acl create -c project -g deploy -p meetup -j service-demo -a read,run,kill >> /etc/rundeck/deploy.aclpolicy
rd-acl test -c project -g deploy -p meetup -j service-demo -a read,run,kill -v
```

### Node test / stage

```bash
rd-acl test -c project -g deploy -p meetup -n test
rd-acl test -c project -g deploy -p meetup -n test -a read,run
rd-acl create -c project -g deploy -p meetup -n test -a read,run >> /etc/rundeck/deploy.aclpolicy
rd-acl create -c project -g deploy -p meetup -n stage -a read,run >> /etc/rundeck/deploy.aclpolicy
rd-acl test -c project -g deploy -p meetup -n test -a read,run
```
