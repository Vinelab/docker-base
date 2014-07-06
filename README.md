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

### Supervisor
#### Adding Services
To add a service to be managed by supervisor include the *ini* file of the program in `/etc/supervisord.d/` with a `.ini`
extension and tell supervisor about it with `supervisorctl reread`.

#### Status
Viewing the status over HTTP requires the *inet http* server of supervisor to run and
expose itself on port `9001` and this is the default behavior of this container.

**Run exposing supervisor's HTTP status server port:**

- `docker run -d -p 7788:22 -p 9001:9001 vinelab/base`
- visit `http://localhost:9001` (or the equivalent to localhost according to your docker installation)
- the credentials are username: **vinelab** password: **vinelab**
