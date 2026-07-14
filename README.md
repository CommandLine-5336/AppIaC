# APP Infrastructure as Code
## pre-commit hook installation
* In order to install pre-commit hooks in terminal execute following commands:
1.
    * For Ubuntu `sudo apt install pre-commit`
    * For windows `pip install pre-commit`
    * For Mac `brew install pre-commit`
2. `pre-commit install` inside of the folder with .pre-commit-config.yaml
3. Done

## Ansible Roles Overview

Infrastructure is provisioned via four Ansible roles: `consul`, `db`, `web`, `lb`. Each role follows the same structure (`tasks/`, `templates/`, `handlers/`, `defaults/`) and is responsible for one server type only.

### consul

Installs and configures a Consul agent on every server. Handles cluster formation, service discovery, and security hardening (gossip encryption, ACL).

**Key variables** (`roles/consul/defaults/main.yml`):

|Variable|Description|
|---|---|
|`consul_server`|`true` on the Consul server host, `false` on all clients (db, web, lb)|
| `consul_bind_addr` | IP address the agent binds to (set per-host in inventory) |
| `consul_retry_join` | List of Consul server addresses used to join the cluster |
| `consul_gossip_key` | Shared encryption key for gossip traffic between agents. **Must be generated once** (`consul keygen`) and passed as a secret — never hardcoded in the repo |
| `consul_acl_enabled` | Enables ACL (`default_policy = deny`) |
| `consul_agent_token` | Token used by agents for registration and service discovery. **Must be generated once** on the Consul server (`consul acl bootstrap` + `policy create` + `token create`) and passed as a secret |

**Setup note:** gossip key and ACL bootstrap are one-time manual steps performed directly on the Consul server — see "Set up secrets" below for how they're passed to the pipeline. Ansible only distributes already-generated values.

### db

Installs MariaDB, creates the application database and user, and registers the `db` service in Consul with a TCP health check.

### web

Deploys the Flask application (via Gunicorn + Nginx), sets up the `.env` file from secrets, and registers the `web` service in Consul with an HTTP health check.

### lb

Configures Nginx as a load balancer. Instead of hardcoded backend IPs, it runs `consul-template`, which watches Consul for healthy `web` instances and automatically regenerates the Nginx upstream config — no manual editing required when web servers are added, removed, or fail a health check.

### Service discovery flow

1. Each service (`db`, `web`, `lb`) registers itself in Consul on startup, with a periodic health check (10s interval)
2. `consul-template` on the `lb` host reads the list of healthy `web` instances from Consul and regenerates `nginx.conf` automatically
3. If a `web` instance fails its health check, it's excluded from the config on the next render — no manual load balancer reconfiguration needed

## How to set up Jenkins with Ansible

1. [Install Jenkins](https://www.jenkins.io/doc/book/installing/linux/#debianubuntu)

2. Go to <http://jenkins_machine_ip:8080> (or <http://localhost:8080>
if setting up on a host machine) and follow installation guide

    * When prompted, install recommended plugins

3. [Install Ansible globally](https://docs.ansible.com/projects/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-ubuntu)

4. [Install Jenkins plugin for Ansible](https://plugins.jenkins.io/ansible/)

    * Go to Manage Jenkins -> Plugins -> Available plugins
    * Search 'Ansible' and download first option
    * Go to Manage Jenkins -> Tools -> Ansible installation -> Add Ansible
    * Name the installation `Ansible` and use `/usr/bin` as path
    * Click 'Save'

5. Import pipeline:

    * Click New Item on the home page
    * Select 'Pipeline' item type and name your pipeline
    * Go to Pipeline -> Definition and choose
    'Pipeline script from SCM'
    * Choose Git and paste this repository URL
    * Paste `refs/heads/main` as 'Branch Specifier'
    * Click 'Save'

6. Set up secrets:

    * Go to Manage Jenkins -> Credentials -> System ->
    Global credentials -> Add Credentials
    * Add SSH key for the virtual machines and use `vm_ssh_key` as the
    credentials' ID
    * Add AWS region `app_s3_region` and bucket name `app_s3_bucket`
    * Add secrets for the playbooks with the following IDs:

    1. `database_name` (Secret text)
    2. `database_credentials` (Username with password)
    3. `flask_secret_key` (Secret text)
    4. `app_s3_bucket` (Secret text)
    5. `app_s3_region` (Secret text)
    6. `gossip_key` (Secret text) - it should be previously generated on the Consul server
    7. `agent_token` (Secret text) - it should be previously generated on the Consul server

7. Run the pipeline
