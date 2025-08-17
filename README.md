

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
| VAR     | default | memo                                                                        |
| ------- | ------- | --------------------------------------------------------------------------- |
| TZ      | UTC     | TIME_ZONE                                                                   |
| RESTART | no      | see  https://github.com/compose-spec/compose-spec/blob/main/spec.md#restart |

### A. On localhost variable
| VAR | default | memo |
| --- | ------- | ---- |
| -   | -       | -    |

### B. On ipvlan network
| VAR                   | default | memo                     |
| --------------------- | ------- | ------------------------ |
| EXTERNAL_NETWORK_NAME |         | ex: user defined_netwrok |
| SQUID_IP_ADDRESS      |         | ex: 192.168.100.2        |