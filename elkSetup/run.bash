#!/bin/bash
here=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
scripts_path=$(realpath $here/scripts)


# ELK Setup
bash $scripts_path/setup.bash

# Elasticsearch
bash $scripts_path/elastic.bash "512m"

# Kibana
bash $scripts_path/kibana.bash "0.0.0.0" "5601"

# Logstash
