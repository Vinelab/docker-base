# Base
A base image that allows simple ssh access through ssh keys using `supervisord` to keep the container running allowing
it to manage any added services as well.

### Setup
- add `docker_ssh_rsa` to your ssh agent:
    - `eval ssh-agent`
    - `ssh-add docker_ssh_rsa`

### Run
- `docker run -d -p 7788:22 vinelab/base`
- access using ssh: `ssh root@localhost -p 7788` or the equivalent to `localhost` according to your docker installation.

### Adding Services
To add a service to be managed by supervisor include the *ini* file of the program in `/etc/supervisord.d/` with a `.ini`
extension.
