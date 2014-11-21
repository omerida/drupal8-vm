# Drupal 8 Vagrant Box

This is a basic Vagrant box running Debian 7.4 with PHP, Apache, and MySQL configured for running Drupal 8.

To build the box:

~~~~
vagrant up
~~~~

## Drupal source ##

The first time the provisioner runs, it will download Drupal 8 source code into a `web` directory and copy a default configuration for the database to work.

## Development URL ##

The default URL is http://drupal8.dev/ To access it, add the following line to your `hosts` file:

~~~~
192.168.33.10   drupal8.dev
~~~~