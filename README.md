# puppet-soe 

## Overview

Everyone's Puppet environment generally needs a Standard Operating Environmet
(SOE) or base module of some kind to setup general sensible good things for
your environment.

This can be a hurdle for getting started with Puppet, so this module includes
various sensible SOE configurations that you can either pickup as include as-is
or fork the module to adjust and meet your own specific needs.


## Key Features

* Properly configure FQDN of server.
* Configure swap space on low memory boxes.
* Setup automatic updates.
* Configure NTP and timezones
* Install Newrelic server agent.
* And much more...



## Usage

Include the module and dependencies in your `Puppetfile` (if using recommended
r10k workflow):

    mod 'jethrocarr/soe'
    mod 'fsalum/newrelic'
    mod 'petems/swap_file'
    mod 'puppetlabs/ntp'
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

The SOE module is somewhat configurable - there are a large number of
parameters defined in `manifests/params.pp`, along with explainations of their
purpose. You can change any of them via Hiera override rather than needing to
fork the module simply to change a param.

For example, the config option `$manage_time_zone` can be set by adding the
following line to your Hiera data, which will take precedence.

    soe::manage_time_zone: 'Some/Other/Timezone'

Of course this SOE isn't going to meet every use case. Where it falls short,
you are welcome to do any of the following:

1. Submit a PR if it's a useful feature to many other people (rather than just
   yourself or some very unique rare distribution).

2. Create a site-specific module (eg `s_soe`) and add additional Puppet classes
   there to add missing functionality, allowing you to keep your copy of `soe`
   in-sync with upstream.

3. Fork this module and adjust as required to suit your needs. Just be aware it
   will make it harder to take advantage of new additions in future and you'll
   have to merge every so often.

4. Toss it all out and write something better!


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

