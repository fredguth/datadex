FROM mcr.microsoft.com/vscode/devcontainers/python:3.10

RUN apt-get update && apt-get install -y nodejs npm g++

# Install dbt
RUN pip3 --disable-pip-version-check --no-cache-dir install \
    duckdb==0.5.1 dbt-duckdb==1.2.2 dbt-osmosis==0.7.16 \
    && rm -rf /tmp/pip-tmp

# Configure Workspace
WORKDIR /workspaces/datadex
ENV DBT_PROFILES_DIR=/workspaces/datadex

# Install Rill Developer
RUN curl -s https://cdn.rilldata.com/install.sh | bash
