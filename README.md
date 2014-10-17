ssh-proxy-git
=============

Prototype of using single-use keys when proxying SSH connections from an SSH proxy to a Git backend.

Running
-------

In this directory, create at least 1 keypair for a user, like so:

```
ssh-keygen -f user1 -q -N ""
```

Copy the public key into `mockauth/keys`

Run the mock auth server:

```
cd mockauth
bundle
AUTH_SERVER=... GIT_PORT=8200 GIT_SERVER=... ruby app.rb -o 0.0.0.0 -p 8000
```

Build the git and ssh images:

```
cd gitcontainer
docker build --rm -t <yourname>/git .
cd ../sshproxy
docker build --rm -t <yourname>/ssh .
```

Run the git container:

```
docker run --name git -d -e AUTH_SERVER=... -p 8200 <yourname>/git
```

Run the ssh proxy container:

```
docker run --name ssh -d -e AUTH_SERVER=... -p 8100 <yourname>/ssh
```

Set up your `$HOME/.ssh/config` so git will work:

```
Host sshproxy
  Hostname localhost
  Port 8100
```

Try to git clone:

```
git clone user1@sshproxy:repo1
```
