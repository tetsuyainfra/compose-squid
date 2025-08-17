

## HOW TO MERGE for each compose file
```
make
```

## How to use
### A. On localhost
```
# use default bridge
$ docker compose up
# Same meaning as the following command
$ docker compose -f compose.yml up
```

### B. On ipvlan network
```
# use other network by ipvlan driverA
$ docker network create --driver ipvlan -o parent=eth1 --gateway 192.168.100.1 --subnet 192.168.100.0/24 user_defined_net

$ vi .env
EXTERNAL_NETWORK_NAME=user_defined_net
SQUID_IP_ADDRESS=192.168.100.2

$ docker compose -f compose-ipvlan.yml up 
```

## How to test
```
# if you choice "A. On localhost"
./test.sh

# if you choice "B. On other network"
export $(cat .env | xargs) && ./test.sh
```

## common .env variable
| VAR                 | default                          | memo                                                                   |
| ------------------- | -------------------------------- | ---------------------------------------------------------------------- |
| TZ                  | UTC                              | TIME_ZONE                                                              |
| RESTART             | no                               | https://github.com/compose-spec/compose-spec/blob/main/spec.md#restart |
| CACHE_DIR           | ufs /var/cache/squid 1000 16 256 | https://www.squid-cache.org/Doc/config/cache_dir/                      |
| MAXIMUM_OBJECT_SIZE | 256 MB                           | https://www.squid-cache.org/Doc/config/maximum_object_size/            |
| CACHE_MEM           | 256 MB                           | https://www.squid-cache.org/Doc/config/cache_mem/                      |
| MAX_FILEDESCRIPTORS | 1024                             | https://www.squid-cache.org/Doc/config/max_filedescriptors/            |

### A. On localhost variable
| VAR | default | memo |
| --- | ------- | ---- |
| -   | -       | -    |

### B. On ipvlan network
| VAR                   | default | memo                     |
| --------------------- | ------- | ------------------------ |
| EXTERNAL_NETWORK_NAME |         | ex: user defined_network |
| SQUID_IP_ADDRESS      |         | ex: 192.168.100.2        |



# NOTICE
- Dockerfile, entrypoint.sh from [ubuntu/squid](https://code.launchpad.net/~ubuntu-docker-images/ubuntu-docker-images/+git/squid)