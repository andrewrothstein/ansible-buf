andrewrothstein.buf
=========
[![Build Status](https://travis-ci.org/andrewrothstein/ansible-buf.svg?branch=master)](https://travis-ci.org/andrewrothstein/ansible-buf)

Installs [buf](https://buf.build/)

Requirements
------------

See [meta/main.yml](meta/main.yml)

Role Variables
--------------

See [defaults/main.yml](defaults/main.yml)

Dependencies
------------

See [meta/main.yml](meta/main.yml)

Example Playbook
----------------

```yml
- hosts: servers
  roles:
    - andrewrothstein.buf
```

License
-------

MIT

Author Information
------------------

Andrew Rothstein <andrew.rothstein@gmail.com>
