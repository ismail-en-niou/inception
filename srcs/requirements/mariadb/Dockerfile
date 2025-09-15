# Use the latest Debian as the base image
FROM debian:latest

# Set the working directory inside the container to /mariadb
WORKDIR /mariadb

# Update the package list to get the latest package information
RUN apt-get update

# Install MariaDB server package non-interactively
RUN apt-get install mariadb-server -y

# Copy the setup script from the host machine to the container's working directory
COPY conf/setup_mariadb.sh .

# Make the setup script executable
RUN chmod +x ./setup_mariadb.sh

# Expose port 3306 to allow external connections to the MariaDB server
EXPOSE 3306

# Set the default command to run when the container starts
CMD ["./setup_mariadb.sh"]