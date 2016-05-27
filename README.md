# VM Stuffs

Trying to get everybody to install hadoop and spark on thier environment as part of the tutorial is a path to dispare and madness.  Accordingly, we're going to provide everybody with a VM with everything pre-installed to minimize the install-fest portion of the day.

We're using vagrant to manage the VM as it's free and can run on most sane platforms.

## Getting started

Before you can do anything you will need to install [Vagrant](https://www.vagrantup.com/downloads.html) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads).

One you have vagrant installed, you will also need to run the following command:

```
vagrant plugin install vagrant-hostmanager
```

## Pick a config

Before you start a VM you need to pick a config.  Hadoop is a memory hungry monster that is designed to use all of the available resources of large server hardware.  Accordingly, it's a bit tricky to run on machines with fewer resources.

For this tutorial, we prepared two configs.  One config is designed for machines with lots of RAM and a more limited config for smaller machines.

If your computer has 8GB of RAM or more, copy the file named `Vagrantfile-Big` into a new file named `Vagrantfile`.
Otherwise, copy the file named `Vagrantfile-Small` into a new file named `Vagrantfile`.

## Launch your VM

Once you have picked your config, make sure your working directory is the root of this checkout and then run:

```
vagrant up
```

At some point in the setup process it will ask you for a password.  You will want to enter the admin password for your computer.  This is necessary to update your hosts file with an entry for the virtual machine.

As the `vagrant up` command runs you may see both red and green text, this is normal and expected.

## Accessing your VM

All files in this directory will be available and synced to the vm in the `/vagrant` directory.  Makes it easy to edit files locally but then run them on the vm.

To ssh into the vm, run:

```
vagrant ssh
```

## Stopping your VM

When you are done, but want to retain the data on your VM (e.g. not start the process over from scratch), run:

```
vagrant halt
```

This shuts down your VM gracefully.  When you want to launch your VM again you can just run `vagrant up` again (don't worry, it won't need to go through the whole bootstrap proces again)

When you are really done with the VM and either want to start fresh or reclaim the disk space used by the VM, run:

```
vagrant destroy
```
You will be prompted to confirm.  Once you confirm the VM will be stopped and all files associated with the vm will be deleted.

After running `vagrant destroy` you can run `vagrant up` to rebuild the VM, but it will be starting from scratch and any data you generated or placed on the VM will no longer be available.


## Sample Data

As part of the VM's setup process, it will automatically download some sample data that we'll be using in the tutorial and load in to both the local file system and HDFS on your VM.

We have also included a script that will rebuild/reload your sample data.  If for whatever reason, you need to get the latest version of the sample data the the following steps:

  1.  Navigate to the directory containing this file in your shell.
  2.  Run `vagrant ssh`
  3.  Run `cd /vagrant`
  4.  Run `./refresh_data.sh`

During the tutorial there are two data sets that you will need to care about.  Below are detailed descriptions of those data sets and where to find them.

### 1.usa.gov Decodes

At Bitly, our name for a redirect event is a decode.  Whenever we perform a redirect, we generate a JSON object with information about the event (details below).  Obviously, we don't generally hand out custome data to random people, but thankfully one of our customers (the [GSA](http://http://www.gsa.gov/), an agnecy within the US Goverment) has made a portion of their Bitly data available as an open data set.  Whenever any Bitly user shortens a link to a list of known Govnernment domains, we send that click information over to the GSA.  From there, they sanitize the data a bit and make it available as a [open data set](https://github.com/usagov/1.USA.gov-Data).

On your VM you will be able to find this data set at `/vagrant/sample_data/1usagov_data` and in HDFS at `hdfs:///user/vagrant/sample_data/1usagov_data`.

Below is a sample decode object as well as a description of the provided fields:

```JSON
{
  "h": "1W6dSaK",
  "g": "1W6dKrN",
  "l": "peacecorps",
  "hh": "1.usa.gov",
  "u": "https://passport.peacecorps.gov/2015/04/20/4-reasons-not-to-a-hire-a-returned-peace-corps-volunteer/",
  "r": "http://lm.facebook.com/lsr.php?u=http%3A%2F%2F1.usa.gov%2F1W6dSaK&ext=1463954955&hash=Ackfd3haQeCLXm8mOVq2DqC6gb8a7BEaz7aNQ9IWvrPMpA&_rdr",
  "a": "Mozilla/5.0 (Linux; Android 4.4.3; KFTHWA Build/KTU84M) AppleWebKit/537.36 (KHTML, like Gecko) Silk/49.3.1 like Chrome/49.0.2623.105 Safari/537.36",
  "i": "",
  "t": 1463954895,
  "k": "",
  "nk": 0,
  "hc": 1463750168,
  "_id": "dde88210-97bc-6cbd-738d-1c6a7beb77be",
  "al": "en-US,en;q=0.8",
  "c": "US",
  "tz": "America/New_York",
  "gr": "ME",
  "cy": "Topsham",
  "mc": 500,
  "ll": [
    43.9602,
    -69.9654
  ]
}
```

| Key |  Name  |  Description |
| --- | ------ | ------------ |
|  h  | User Hash | Unique hash that we generate for each combination of shortened long URL and login.  Useful for referencing sepcific Bitlinks. |
|  g  | Global Hash | Unique hash that we generate and share for all instances of a long URL.  Useful for referencing documents/URLs. |
|  l  | Login | User who originally shortened the link.  There are two special users of "Annonymous" and "Bitly" that are used for anon shortening and global hash generation. |
|  hh | Host Header | Host header of this redirect request (some Bitlinks are valid on multiple short domains). |
|  u  | URL | Long URL that the user was redirected to. |
|  r  | Referrer | Referrer header of the Bitlink request. |
|  a  | User Agent | User Agent header of the Bitlink request. |
|  i  | IP Address | Will always be empty in this data set to protect user privacy. |
|  t  | Timestamp | Unix timestamp of when the decode occurred. |
|  k  | Cookie | Will always be empty in this data set to protect user privacy. |
|  nk | Known Cookie | Will be 0 if this cookie has not been seen before, 1 if it has. |
|  hc | Hash Creation | Unix timestamp of when the Bitlink was shortened. |
|  _id| ID | UUID unique to this decode. |
|  al | Accept Language | Accept Language header of the decode request. |
|  c  | Country | 2 letter country code based on the MaxMind GeoIP dataset. |
|  tz | Timezone | Timezone based on MaxMind GeoIP dataset. |
|  gr | Geo Region | Based on MaxMind GeoIP dataset (optional). |
|  cy | City | Based on MaxMind GeoIP dataset (optional). |
|  mc | MetroCode/DMA Code | Based on MaxMind GeoIP dataset (optional, [lookup table](https://developers.google.com/adwords/api/docs/appendix/cities-DMAregions)). |
|  ll | Latitude, Longitude | Bsaed on MaxMind GeoIP dataset (optional). |

### 18F's dotgov-domains Data

We'll also be using data based on the [mapping](https://github.com/GSA/data/blob/gh-pages/dotgov-domains/2014-12-01-full.csv) of domains to agencies provided by [18F](https://18f.gsa.gov/).  To simplify things in the tutorial we've run a procees to generate per-global hash mappings (URLs are kind of complicated).

You can find this mapped data in your VM at `/vagrant/sample_data/agency_map` and on HDFS at `hdfs:///user/vagrant/sample_data/agency_map`.

Below is an example mapping object.

```JSON
{
  "Global Hash": "1scWYcS",
  "City": "Bethesda",
  "State": "MD",
  "Agency": "Department of Health And Human Services",
  "Hostname": "www.ncbi.nlm.nih.gov",
  "Domain Name": "nih.gov",
  "Domain Type": "Federal Agency"
}
```

Note that the `Global Hash` field in this object, maps directly to the `g` field in the decode objects.


## Support

If you run in any problem or have any questions, feel free to reach out to me at sean@seanoc.com.  Otherwise, we'll be taking a few minutes at the start of the tutorial to handle any remaining environment setup issues.


## Web UI Links

Some handy links to web UIs for services running on your VM (this will only work when your VM is running):

[Hadoop UI](http://my-hadoops:8088/cluster)


