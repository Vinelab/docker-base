# Docker-[ ]-Base
A basic setup with typical utitlity packages running [supervisord](http://supervisord.org).

## Packages
* tar
* vim
* cron
* wget
* rsyslog

## Usage
* simple `docker run -d vinelab/base`
* stick to the session with `docker run -i -t --rm vinelab/base bash`

### Supervisord

###### username: *vinelab*
###### password: *vinelab*

#### Adding Services

To add a service to be managed by supervisor mount an *.ini* file containing program(s) configuration to
`/etc/supervisord.d/` and use `docker exec` to manage the `supervisorctl`.

#### Status
Viewing the status over HTTP requires the *inet http* server of supervisor to run and
expose itself on port `9001` and this is the default behavior of this container.

**Run exposing supervisor's HTTP status server port**

- `docker run -d -p 9001:9001 vinelab/base`
- visit `http://[docker host]:9001`
