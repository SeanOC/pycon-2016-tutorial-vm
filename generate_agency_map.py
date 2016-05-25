#!/usr/bin/env python
import argparse
import sys
from csv import DictReader
from urlparse import urlparse

import ujson as json


if __name__ == '__main__':
    processed = set()
    parser = argparse.ArgumentParser()
    parser.add_argument('--agencies-file', dest='agencies_filename')
    args = parser.parse_args()

    agency_data = []
    with open(args.agencies_filename, 'r') as agencies_file:
        reader = DictReader(agencies_file)

        for row in reader:
            row['Domain Name'] = row['Domain Name'].lower()
            agency_data.append(row)

    for line in sys.stdin:
        print "'{}'".format(line)
        decode = json.loads(line)

        if decode['g'] in processed:
            continue

        parsed_url = urlparse(decode['u'])

        result = {'Global Hash': decode['g'], 'Hostname': parsed_url.hostname}

        for site in agency_data:
            if parsed_url.hostname.endswith(site['Domain Name']):
                result.update(site)
                break

        processed.add(decode['g'])
        if 'Domain Name' in result:
            print json.dumps(result)