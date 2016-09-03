# puppet-soe 

## Overview

Everyone's Puppet environment generally needs a Standard Operating Environment
(SOE) or base module of some kind to setup general sensible good things for
your environment so that you don't have to re-define the same common set of
modules and configurations every time.

This can be a hurdle for getting started with Puppet, so this module includes
various sensible SOE configurations that you can either pickup as include as-is
or fork the module to adjust and meet your own specific needs.

It's primarily intended for internet-connected GNU/Linux servers, eg mail, web
or other application servers rather than desktops and makes a number of 
assumptions on that basis.


## Key Features

* Configure host FQDN
* Configure NTP and timezones
* Configure swap space on low memory boxes.
* Configure SSH no-password logins.
* Enable automatic updates.
* Enable repos such as EPEL.
* Install core packages
* Install Newrelic server agent.
* And much more...


## Usage

Include the module and dependencies in your `Puppetfile` (if using recommended
r10k workflow):

    mod 'jethrocarr/soe'
    mod 'jethrocarr/digitalocean'
    mod 'jethrocarr/hostname'
    mod 'jethrocarr/repo_jethro'
    mod 'jethrocarr/virtual_user'
    mod 'fsalum/newrelic'
    mod 'petems/swap_file'
    mod 'puppetlabs/apt'
    mod 'puppetlabs/ntp'
    mod 'puppetlabs/stdlib'
    mod 'saz/sudo'
    mod 'saz/timezone'
    mod 'stahnma/epel'

Add the SOE module to your node definitions (usually in `site.pp` or your
external node classifier). Note that we make use of Puppet stages, which
normally is kind of horrible, but it's really needed to allow the SOE module
to setup repositories used by later modules.

    # Apply SOE before any other subsequent modules
    stage { 'soe': before => Stage['main'] }
    class { 'soe': stage => soe }


## Configuration

Because of the nature and scale of this module, rather than creating a
parameter for every single configuration option, the decision has been made
to enforce the use of Hiera for anyone wishing to override or disable any
part of the configuration.

If we followed the popular Puppet `params.pp` pattern of configuration, we'd
instead end up with hundreds of lines of confusing logic and params that is
much more tidy if homed in the sub classes themselves.

Each sub class includes logic that determines if it's contents is appropiate
for any given system. For example, the various entiries in `manifests/fix/`
check to see if the system actually needs their config, even if enabled.

In addition, every sub-class features an `enable` param that can be set to
`false` in Hiera to disable that configuration component.

For example, if you really didn't want the include "no automatic tmpfs mount on
/tmp on RHEL" fix, you could set the following in Hiera:

    soe::fix::rhel_systemd_tmpfs::enable: false

This works becauses we have the following logic in
`manifests/fix/rhel_systemd_tmpfs.pp` which states:

    class soe::fix::rhel_systemd_tmpfs (
      $enable = true,
    ) {

      if ($enable) {
        # ... do stuff

Remember that with Hiera if you place configuration in `common.yml` it will
apply to every single server, but you can also do much more targeted
configuration if desired.

Some sub-classes contain additional params, all of which you can adjust via
Hiera. It is best to review each file to learn about it's functionality from
the comments at the header.


Of course even with this configurability, this SOE module isn't going to meet
every use case. Where it falls short, you are welcome to do any of the following:

1. Submit a PR if it's a useful feature to many other people (rather than just
   yourself or some very unique rare distribution).

2. Create a site-specific module (eg `s_soe`) and add additional Puppet classes
   there to add missing functionality, allowing you to keep your copy of `soe`
   in-sync with upstream. 

3. Fork this module and adjust as required to suit your needs. Just be aware it
   will make it harder to take advantage of new additions in future and you'll
   have to merge every so often.
   
4. Or you can mix & match, with your own `s_soe` module with some of your own
   classes, but then reference selected classes back from `soe` as you desire
   them.

5. Toss it all out and write something better! This module was written to meet
   my specific requirements, yours might be completely different.


## Requirements

Supported on the following GNU/Linux platforms:

* Ubuntu
* Debian
* CentOS

PRs welcome for other mainstream distributions, MacOS or FreeBSD. This module
is probably too UNIX-specific to really help anyone on the Windows platform.


## Contributions

All contributions are welcome via Pull Requests including documentation fixes
or compatibility fixes for supporting other distributions (or other operating
systems).


## License

This module is licensed under the Apache License, Version 2.0 (the "License").
See the LICENSE or http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

