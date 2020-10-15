##### USER'S BUILD IMAGE #####

FROM rocker/verse:3.6.3

# Add user
RUN useradd svcusr
    # mkdir -p /home/svcusr && \
    # useradd -u 88888 -g 20 svcusr && \
    # echo "svcusr :testing" | chpasswd

# ENTRYPOINT ["/init"]

# Copy the Rscript from Repo into Container
# Run the Rscript in the Container

COPY db-rscript.R /
USER svcusr
CMD Rscript ./db-rscript.R lalarepo-100