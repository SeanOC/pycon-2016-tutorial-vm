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


## Support

If you run in any problem or have any questions, feel free to reach out to me at sean@seanoc.com.  Otherwise, we'll be taking a few minutes at the start of the tutorial to handle any remaining environment setup issues.


## Web UI Links

Some handy links to web UIs for services running on your VM (this will only work when your VM is running):

[Hadoop UI](http://my-hadoops:8088/cluster)


