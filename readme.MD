# NGINX acme-challenge validation
This repo contains the steps and code to register free domain, generate free ssl certificate, valid for 3 months, and store them in GCP TLS secret (optional).  
For this example I'll explain on example.com domain.

1. Register free domain in no-ip.com. You should redirect the new domain (can be temporarily) to the server (AKA **registration server**) which will respond to the acme-challenge by Let's Encrypt (check out the [acme description page](https://letsencrypt.org/docs/challenge-types/)).  
Make sure you have port 80 open on the selected registration server for incoming HTTP requests.
2. On your local machine, Install certbot.
    ```bash
    # Add apt repo
    sudo add-apt-repository ppa:certbot/certbot

    # update apt
    sudo apt-get update

    # install certbot
    sudo apt-get install python-certbot-apache
    ```
3. Create the acme-challenge.  
    Using certbot tool run the following command.
    ```bash
    sudo certbot certonly --manual -d example.com
    # you can supply more then one -d flags for multiple domain like (www.example.com)
    # sudo certbot certonly --manual -d example.com -d www.example.com
    ```
    Now, the challenge is created and you should see data and specific link for the challenge requests.
    Something like this:  
    **Link**: `example.com/.well-known/acme-challenge/2NKiiETgQdPmmjlM88mH5uo6jM98PrgWwsDslaN8`  
    The '2NKiiETgQdPmmjlM88mH5uo6jM98PrgWwsDslaN8' should be static file.  
    **Data within the file**: `2NKiiETgQdPmmjlM88mH5uo6jM98PrgWwsDslaN8.BBz59IBHlymZfSj1S9mOlQkts7LXG8-gkycr7njT`.  
    This screen will hold and wait for you to finish setup your registration server.
4. Setup NGINX on docker on any webserver expose to the internet (on the registration server).
    ```bash
    # install docker and add current user to docker group
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    # you need to refresh your shell for this to take effect

    # install docker-compose
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    ```
    Clone this repo, enter it's root directory, create the extended path which requested by the active acme-challenge, continue using the `.well-known/acme-challenge` directory.  
    Then, create the challenge file with the challenge data in it.  
    Finally, go back to the repo root directory and run the docker-compose file.
    ```bash
    docker-compose up -d
    ```
5. Test the server file response with `curl` command or your browser.
    ```bash
    curl http://example.com/.well-known/acme-challenge/YOUR_CHALLENGE_FILE_NAME
    ```
    If all configure correctly you should see the challenge data.
6. Start the challenge.  
   On your active challenge (with the certbot) terminal, press the `enter` key.  
   The certbot using the Let's encrypt server will verify your domain and challenge file.
   If all goes smooth, you should get the success challenge message and the certs files will be created in the following path owning by root.
   ```bash
   # /etc/letsencrypt/live/example.com/fullchain.pem
   # /etc/letsencrypt/live/example.com/privkey.pem
   ```
7. Optional - configure certs file in GCP TLS secret.
    ```bash
    sudo cp /etc/letsencrypt/live/example.com/fullchain.pem .
    sudo cp /etc/letsencrypt/live/example.com/privkey.pem .
    chown $USER:$USER fullchain.pem
    chown $USER:$USER privkey.pem

    # create secrets - secret name is web-tls
    ./create_gcp_ssl_cert_secret.sh
    ```

## More useful command  
`kubectl delete secret web-tls`

