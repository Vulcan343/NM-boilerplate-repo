We created a database for The Non-Dairy Barn, a franchise that specializes in selling non-dairy milk alternatives. The NDB is a brick and mortar storefront that sells milk alternatives, but currently lacks the infrastructure needed for e-commerce and internal employee and inventory management. Our database holds information about suppliers, employees, products, individualized store inventory, payroll, and customer information. In terms of our API implementation, we constructed easy-to-navigate user interfaces to view milk-alternative products available for purchase and where they can buy them. Customers can enjoy this search feature, while store employees can use the app to add, delete, and update products in the database as well as worker and customer information.

# MySQL + Flask Boilerplate Project

This repo contains a boilerplate setup for spinning up 3 Docker containers: 
1. A MySQL 8 container for obvious reasons
1. A Python Flask container to implement a REST API
1. A Local AppSmith Server

## How to setup and start the containers
**Important** - you need Docker Desktop installed

1. Clone this repository.  
1. Create a file named `db_root_password.txt` in the `secrets/` folder and put inside of it the root password for MySQL. 
1. Create a file named `db_password.txt` in the `secrets/` folder and put inside of it the password you want to use for the a non-root user named webapp. 
1. In a terminal or command prompt, navigate to the folder with the `docker-compose.yml` file.  
1. Build the images with `docker compose build`
1. Start the containers with `docker compose up`.  To run in detached mode, run `docker compose up -d`. 

1. Once the docker containers are running, go to the url for editing Appsmith 
1. Then import the nm-appsmith-repo into the Appsmith container
1. From there deploy and enjoy your NDB webapp!




