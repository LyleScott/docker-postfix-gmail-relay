# docker-postfix-gmail-relay
A docker image that uses postfix as a relay through gmail. Useful to link to other images.

## Configurables

```
SYSTEM_TIMEZONE = UTC or America/New_York
MYNETWORKS = "10.0.0.0/8 192.168.0.0/16 172.0.0.0/8"
EMAIL = gmail or google domain
EMAILPASS = password (is turned into a hash and this env variable is removed at boot)
```

## Example

```bash
docker run -i -t --rm \                                                        
    --name gmailrelay \
    -p 9025:25 \
    -e SYSTEM_TIMEZONE="America/New_York" \
    -e MYNETWORKS="10.0.0.0/8 192.168.0.0/16 172.0.0.0/8" \                    
    -e EMAIL="YOUR_EMAIL@gmail.com" \
    -e EMAILPASS="your_password" \
    postfix-gmail-relay
```

